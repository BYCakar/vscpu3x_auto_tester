"""Command-line orchestration for one test or a persistent-connection suite."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import logging
from pathlib import Path
import sys
import time
import traceback
from typing import Callable, Sequence

from .constants import (
    DEFAULT_BAUD_RATE,
    DEFAULT_DEVICE_ID,
    DEFAULT_MODBUS_TIMEOUT_SECONDS,
    DEFAULT_POLL_INTERVAL_SECONDS,
    DEFAULT_TEST_TIMEOUT_SECONDS,
    DEFAULT_UART_SETTLE_TIMEOUT_SECONDS,
    REGISTERS,
    SIM_TEST_FAILURE,
    SIM_TEST_SUCCESS,
)
from .inputs import (
    ConfigurationError,
    discover_tests,
    prepare_test_inputs,
    validate_test_directory,
)
from .memrw import run_memrw_test
from .models import TestInputs, TestResult
from .modbus_transport import InfrastructureError, PymodbusTransport
from .report import (
    close_logger,
    configure_test_logger,
    create_suite_output_directory,
    create_test_output_directory,
    iso_now,
    write_result_json,
    write_suite_summary,
)
from .test_runner import TestRunner


DEFAULT_MEMRW_ACCESSES_PER_BLOCK = 8


@dataclass
class PreparedTest:
    name: str
    root: Path
    output_dir: Path
    logger: logging.Logger
    inputs: TestInputs | None = None
    result: TestResult | None = None


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Load and run file-driven VSCPU3x auto-tester applications over Modbus RTU."
    )
    parser.add_argument(
        "test_name",
        help="Immediate directory under vscpu3x_apps/tests, 'all', or the special 'memrw' test.",
    )
    parser.add_argument("uart_device", help="Serial device, for example /dev/ttyUSB0.")
    parser.add_argument("mode", choices=("run", "debug"))
    parser.add_argument(
        "--timeout",
        type=float,
        default=DEFAULT_TEST_TIMEOUT_SECONDS,
        help="Bounded tester/ACTMEM timeout in seconds (default: %(default)s).",
    )
    parser.add_argument(
        "--poll-interval",
        type=float,
        default=DEFAULT_POLL_INTERVAL_SECONDS,
        help="Status polling interval in seconds (default: %(default)s).",
    )
    parser.add_argument(
        "--uart-settle-timeout",
        type=float,
        default=DEFAULT_UART_SETTLE_TIMEOUT_SECONDS,
        help="Post-test UART RX settle timeout in seconds (default: %(default)s).",
    )
    parser.add_argument("--baud-rate", type=int, default=DEFAULT_BAUD_RATE)
    parser.add_argument("--device-id", type=int, default=DEFAULT_DEVICE_ID)
    parser.add_argument(
        "--modbus-timeout",
        type=float,
        default=DEFAULT_MODBUS_TIMEOUT_SECONDS,
        help="Timeout for one Modbus transaction in seconds (default: %(default)s).",
    )
    parser.add_argument(
        "--sim-test-finisher",
        action="store_true",
        help=(
            "Finish RTL/GL simulation after all selected tests by writing Modbus "
            "register 0x0010 (0x0000 for success, 0x0001 for failure)."
        ),
    )
    parser.add_argument(
        "--generated",
        action="store_true",
        help=(
            "Run generate.py and load generated/ inputs. If generate.py is "
            "absent, warn and use pregenerated/ inputs."
        ),
    )
    parser.add_argument(
        "-n",
        "--memrw-accesses",
        type=int,
        default=DEFAULT_MEMRW_ACCESSES_PER_BLOCK,
        metavar="N",
        help=(
            "Random MEMRW locations per 2 KiB SRAM block and main-memory region "
            "(default: %(default)s)."
        ),
    )
    parser.add_argument(
        "--full",
        dest="memrw_full",
        action="store_true",
        help="For the memrw test, cover every implemented memory word except GPIO I/O.",
    )
    parser.add_argument(
        "--seed",
        type=lambda value: int(value, 0),
        help="Integer RNG seed for a reproducible memrw test (decimal or 0x-prefixed).",
    )
    parser.add_argument("-v", "--verbose", action="store_true")
    return parser


def _error_result(
    name: str,
    mode: str,
    uart_device: str,
    message: str,
    *,
    infrastructure: bool,
    result_name: str = "ERROR",
) -> TestResult:
    now = iso_now()
    return TestResult(
        test_name=name,
        mode=mode,
        result=result_name,
        start_time=now,
        end_time=now,
        duration_seconds=0.0,
        uart_device=uart_device,
        errors=[message],
        infrastructure_failure=infrastructure,
    )


def _validate_options(args: argparse.Namespace) -> None:
    if args.timeout <= 0:
        raise ConfigurationError("--timeout must be greater than zero")
    if args.poll_interval <= 0:
        raise ConfigurationError("--poll-interval must be greater than zero")
    if args.uart_settle_timeout <= 0:
        raise ConfigurationError("--uart-settle-timeout must be greater than zero")
    if args.modbus_timeout <= 0:
        raise ConfigurationError("--modbus-timeout must be greater than zero")
    if args.baud_rate <= 0:
        raise ConfigurationError("--baud-rate must be greater than zero")
    if not 0 <= args.device_id <= 247:
        raise ConfigurationError("--device-id must be in the range 0..247")
    if args.memrw_accesses <= 0:
        raise ConfigurationError("--memrw-accesses must be greater than zero")
    if args.test_name == "memrw" and args.generated:
        raise ConfigurationError("--generated is not valid for the memrw test")
    if args.test_name != "memrw" and (
        args.memrw_full
        or args.seed is not None
        or args.memrw_accesses != DEFAULT_MEMRW_ACCESSES_PER_BLOCK
    ):
        raise ConfigurationError(
            "--memrw-accesses, --full, and --seed are valid only for the memrw test"
        )


def _finish_simulation(transport, *, passed: bool, logger: logging.Logger) -> None:
    status = SIM_TEST_SUCCESS if passed else SIM_TEST_FAILURE
    logger.info(
        "Finishing simulation: register=0x%04X status=0x%04X (%s)",
        REGISTERS["SIM_TEST_FINISH_REG"],
        status,
        "success" if passed else "failure",
    )
    transport.write_registers(
        REGISTERS["SIM_TEST_FINISH_REG"], [status], side_effecting=True
    )


def _run_memrw_cli(
    args: argparse.Namespace,
    repository_root: Path,
    transport_factory: Callable[..., object],
) -> int:
    """Run the special destructive MEMRW test without loading an application."""

    output_dir = create_test_output_directory(
        repository_root / "vscpu3x_apps" / "run", "memrw"
    )
    logger = configure_test_logger("memrw", output_dir, verbose=args.verbose)
    started_wall = iso_now()
    started = time.monotonic()
    result = TestResult(
        test_name="memrw",
        mode=args.mode,
        result="ERROR",
        start_time=started_wall,
        end_time=started_wall,
        duration_seconds=0.0,
        uart_device=args.uart_device,
    )
    summary = None
    transport = None
    infrastructure_failure = False
    try:
        logger.info(
            "CLI: test_name=memrw uart_device=%s mode=%s n=%d full=%s seed=%s",
            args.uart_device,
            args.mode,
            args.memrw_accesses,
            args.memrw_full,
            "random" if args.seed is None else args.seed,
        )
        logger.info("Repository root: %s", repository_root)
        logger.info("Output directory: %s", output_dir)
        if args.mode == "debug":
            logger.info("memrw debug mode uses the same access/check flow as run mode")
        transport = transport_factory(
            args.uart_device,
            baudrate=args.baud_rate,
            device_id=args.device_id,
            timeout=args.modbus_timeout,
            logger=logger,
        )
        logger.info(
            "Opened Modbus RTU connection: device=%s baud=%d unit=%d",
            args.uart_device,
            args.baud_rate,
            args.device_id,
        )
        summary = run_memrw_test(
            transport,
            accesses_per_block=args.memrw_accesses,
            full=args.memrw_full,
            seed=args.seed,
            timeout=args.timeout,
            poll_interval=args.poll_interval,
            logger=logger,
        )
        result.result = summary.result
        result.test_completed = summary.completed
        result.errors = list(summary.errors)
        result.warnings = list(summary.warnings)
    except InfrastructureError as exc:
        infrastructure_failure = True
        result.errors.append(str(exc))
        logger.exception("Fatal MEMRW infrastructure failure")
    except Exception as exc:
        infrastructure_failure = True
        result.errors.append(f"unexpected Python exception: {exc}")
        logger.error("Unexpected Python exception:\n%s", traceback.format_exc())
    finally:
        if transport is not None:
            if args.sim_test_finisher:
                try:
                    _finish_simulation(
                        transport,
                        passed=result.passed and not infrastructure_failure,
                        logger=logger,
                    )
                except Exception as exc:
                    infrastructure_failure = True
                    result.errors.append(f"simulation finisher write failed: {exc}")
                    logger.exception("Simulation finisher write failed")
            try:
                transport.close()
            except Exception as exc:
                infrastructure_failure = True
                result.errors.append(f"error while closing Modbus client: {exc}")
                logger.error("Error while closing Modbus client: %s", exc)

        if infrastructure_failure:
            result.result = "ERROR"
            result.infrastructure_failure = True
        result.end_time = iso_now()
        result.duration_seconds = time.monotonic() - started
        extra = None if summary is None else {"memrw": summary.as_dict()}
        write_result_json(result, output_dir, extra_sections=extra)
        logger.info("RESULT: %s", result.result)
        close_logger(logger)

    print(f"MEMRW result: {result.result} ({output_dir})")
    if infrastructure_failure:
        return 2
    return 0 if result.passed else 1


def _log_inputs(prepared: PreparedTest, args: argparse.Namespace, repository_root: Path) -> None:
    assert prepared.inputs is not None
    logger = prepared.logger
    inputs = prepared.inputs
    logger.info(
        "CLI: test_name=%s uart_device=%s mode=%s",
        args.test_name,
        args.uart_device,
        args.mode,
    )
    logger.info("Repository root: %s", repository_root)
    logger.info("Test definition: %s", prepared.root)
    logger.info("Runnable inputs: %s", inputs.root)
    logger.info("Output directory: %s", prepared.output_dir)
    if inputs.generation_output:
        logger.info("Generator output:\n%s", inputs.generation_output)
    logger.info(
        "Recognized input files: %s",
        ", ".join(inputs.recognized_files) if inputs.recognized_files else "none",
    )
    logger.info(
        "Missing input files (documented fallbacks apply): %s",
        ", ".join(inputs.missing_files) if inputs.missing_files else "none",
    )
    for warning in inputs.warnings:
        logger.warning(warning)


def run_cli(
    argv: Sequence[str] | None = None,
    *,
    repository_root: Path | None = None,
    transport_factory: Callable[..., object] = PymodbusTransport,
) -> int:
    parser = build_argument_parser()
    args = parser.parse_args(argv)
    try:
        _validate_options(args)
    except ConfigurationError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    repo = (
        Path(repository_root).resolve()
        if repository_root is not None
        else Path(__file__).resolve().parents[3]
    )
    if args.test_name == "memrw":
        return _run_memrw_cli(args, repo, transport_factory)

    source_root = repo / "vscpu3x_apps" / "tests"
    run_root = repo / "vscpu3x_apps" / "run"
    suite_mode = args.test_name == "all"
    try:
        if suite_mode:
            names = discover_tests(source_root)
        else:
            validate_test_directory(source_root, args.test_name)
            names = [args.test_name]
    except ConfigurationError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    suite_start = iso_now()
    suite_dir = create_suite_output_directory(run_root) if suite_mode else None
    prepared_tests: list[PreparedTest] = []
    results: list[tuple[TestResult, Path]] = []

    # Parse every selected test before opening the serial device. This is
    # particularly important for RTL simulation, where UART time is expensive.
    for name in names:
        root = validate_test_directory(source_root, name)
        output_dir = create_test_output_directory(run_root, name)
        logger = configure_test_logger(name, output_dir, verbose=args.verbose)
        prepared = PreparedTest(name, root, output_dir, logger)
        prepared_tests.append(prepared)
        try:
            prepared.inputs = prepare_test_inputs(
                root, name, use_generated=args.generated
            )
            _log_inputs(prepared, args, repo)
        except ConfigurationError as exc:
            logger.error("Test configuration error: %s", exc)
            prepared.result = _error_result(
                name,
                args.mode,
                args.uart_device,
                str(exc),
                infrastructure=False,
            )
            write_result_json(prepared.result, output_dir)
            results.append((prepared.result, output_dir))

    runnable = [prepared for prepared in prepared_tests if prepared.inputs is not None]
    transport = None
    fatal_infrastructure = False
    executed_count = 0
    if runnable:
        try:
            transport = transport_factory(
                args.uart_device,
                baudrate=args.baud_rate,
                device_id=args.device_id,
                timeout=args.modbus_timeout,
                logger=runnable[0].logger,
            )
            runnable[0].logger.info(
                "Opened Modbus RTU connection: device=%s baud=%d unit=%d",
                args.uart_device,
                args.baud_rate,
                args.device_id,
            )
        except Exception as exc:
            fatal_infrastructure = True
            message = f"Modbus connection failed: {exc}"
            for prepared in runnable:
                prepared.logger.error(message)
                prepared.result = _error_result(
                    prepared.name,
                    args.mode,
                    args.uart_device,
                    message,
                    infrastructure=True,
                )
                write_result_json(prepared.result, prepared.output_dir)
                results.append((prepared.result, prepared.output_dir))

    execution_finished = False
    try:
        if transport is not None:
            for index, prepared in enumerate(runnable):
                if hasattr(transport, "set_logger"):
                    transport.set_logger(prepared.logger)
                runner = TestRunner(
                    transport,
                    uart_device=args.uart_device,
                    mode=args.mode,
                    timeout=args.timeout,
                    poll_interval=args.poll_interval,
                    uart_settle_timeout=args.uart_settle_timeout,
                    logger=prepared.logger,
                )
                try:
                    started = time.monotonic()
                    prepared.result = runner.run(prepared.inputs, prepared.output_dir)
                    executed_count += 1
                except InfrastructureError as exc:
                    fatal_infrastructure = True
                    executed_count += 1
                    prepared.logger.exception("Fatal infrastructure failure")
                    prepared.result = _error_result(
                        prepared.name,
                        args.mode,
                        args.uart_device,
                        str(exc),
                        infrastructure=True,
                    )
                    prepared.result.duration_seconds = time.monotonic() - started
                except Exception as exc:
                    fatal_infrastructure = True
                    executed_count += 1
                    prepared.logger.error(
                        "Unexpected Python exception:\n%s", traceback.format_exc()
                    )
                    prepared.result = _error_result(
                        prepared.name,
                        args.mode,
                        args.uart_device,
                        f"unexpected Python exception: {exc}",
                        infrastructure=True,
                    )
                    prepared.result.duration_seconds = time.monotonic() - started
                write_result_json(prepared.result, prepared.output_dir)
                results.append((prepared.result, prepared.output_dir))

                if fatal_infrastructure:
                    for remaining in runnable[index + 1 :]:
                        message = "suite aborted after fatal infrastructure failure"
                        remaining.logger.error(message)
                        remaining.result = _error_result(
                            remaining.name,
                            args.mode,
                            args.uart_device,
                            message,
                            infrastructure=True,
                            result_name="ABORTED",
                        )
                        write_result_json(remaining.result, remaining.output_dir)
                        results.append((remaining.result, remaining.output_dir))
                    break
        execution_finished = True
    finally:
        if transport is not None:
            if args.sim_test_finisher:
                try:
                    _finish_simulation(
                        transport,
                        passed=(
                            execution_finished
                            and not fatal_infrastructure
                            and executed_count > 0
                            and all(result.passed for result, _ in results)
                        ),
                        logger=runnable[-1].logger,
                    )
                except Exception:
                    fatal_infrastructure = True
                    runnable[-1].logger.exception("Simulation finisher write failed")
            try:
                transport.close()
            except Exception as exc:
                fatal_infrastructure = True
                if runnable:
                    runnable[-1].logger.error("Error while closing Modbus client: %s", exc)

    order = {name: index for index, name in enumerate(names)}
    results.sort(key=lambda pair: order[pair[0].test_name])
    if suite_dir is not None:
        write_suite_summary(
            suite_dir,
            results,
            start_time=suite_start,
            end_time=iso_now(),
        )
        print(f"Suite summary: {suite_dir}")

    for prepared in prepared_tests:
        close_logger(prepared.logger)

    if fatal_infrastructure or executed_count == 0:
        return 2
    return 0 if all(result.passed for result, _ in results) else 1


def main() -> None:
    raise SystemExit(run_cli())
