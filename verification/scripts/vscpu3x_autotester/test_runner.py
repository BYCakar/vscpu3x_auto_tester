"""Per-test loading, execution, checking, and debug collection."""

from __future__ import annotations

from collections.abc import Iterable, Mapping, Sequence
import logging
from pathlib import Path
import time

from .constants import (
    ACTUAL_REGISTERS,
    CHECK_DATA_REGISTERS,
    CHECK_MASK_REGISTERS,
    CMD_FETCH_ACTMEM,
    CMD_FORCE_STOP,
    CMD_SET_PINMUX_BP,
    CMD_TEST_LOAD_RUN,
    CORE_CAPACITIES,
    ERROR_CLEAR_MASK,
    ERROR_MEMRW_ERROR,
    ERROR_PROGRAM_ERROR,
    ERROR_UART_RX_OVERFLOW,
    ERROR_UART_TX_OVERFLOW,
    FILL_UNUSED_PROGMEM_WITH_NOPS,
    MASK_REGISTER_COUNTS,
    MEMORY_CAPACITIES,
    MISMATCH_REGISTERS,
    PROGRAM_REGISTERS,
    PROGMEM_NOP_WORD,
    REGISTERS,
    STATUS_ACTMEM_FETCHING,
    STATUS_BUSY_MASK,
    STATUS_CLEAR_MASK,
    STATUS_ERROR_FLAG,
    STATUS_PROGMEM_LOADING,
    STATUS_TEST_DONE,
    STATUS_TEST_RUNNING,
    UART_CAPACITY_BYTES,
)
from .data import (
    build_dense_program,
    build_sparse_mask,
    contiguous_runs,
    extract_uart_bytes,
    normalize_gpio,
    overlay_uart_bytes,
    pack_u32_be_halfwords,
    ring_advance,
    ring_distance,
    uart_byte_location,
    unpack_u32_be_halfwords,
)
from .mem_parser import ParsedMem
from .models import GpioPattern, TestInputs, TestResult
from .modbus_transport import (
    AmbiguousCommandError,
    InfrastructureError,
    read_register_block,
    write_register_block,
)
from .report import describe_bytes, escaped_bytes, iso_now


def _format_ranges(addresses: Iterable[int]) -> str:
    runs = contiguous_runs(addresses)
    parts = []
    for run in runs:
        parts.append(f"0x{run[0]:X}" if len(run) == 1 else f"0x{run[0]:X}-0x{run[-1]:X}")
    return ", ".join(parts) if parts else "none"


class TestRunner:
    def __init__(
        self,
        transport,
        *,
        uart_device: str,
        mode: str,
        timeout: float,
        poll_interval: float,
        uart_settle_timeout: float,
        logger: logging.Logger,
    ) -> None:
        self.transport = transport
        self.uart_device = uart_device
        self.mode = mode
        self.timeout = timeout
        self.poll_interval = poll_interval
        self.uart_settle_timeout = uart_settle_timeout
        self.logger = logger
        self._rx_start_pointer = 0
        self._gpio = GpioPattern(0, [], [])

    def _read_one(self, address: int) -> int:
        values = self.transport.read_registers(address, 1)
        if len(values) != 1:
            raise InfrastructureError(
                f"malformed transport response at 0x{address:04X}: expected one register"
            )
        return values[0]

    def _write_one(self, address: int, value: int, *, side_effecting: bool = False) -> None:
        self.transport.write_registers(address, [value], side_effecting=side_effecting)

    def _sleep(self) -> None:
        if self.poll_interval:
            time.sleep(self.poll_interval)

    def _wait_idle(self) -> int:
        deadline = time.monotonic() + self.timeout
        while True:
            status = self._read_one(REGISTERS["STATUS_REG"])
            if not status & STATUS_BUSY_MASK:
                return status
            if time.monotonic() >= deadline:
                raise InfrastructureError(
                    f"tester remained busy before load (STATUS=0x{status:04X})"
                )
            self._sleep()

    def _ensure_pinmux(self) -> None:
        command = self._read_one(REGISTERS["CMD_REG"])
        if command & CMD_SET_PINMUX_BP:
            self.logger.info("Pinmux bypass is already enabled")
            return
        self.logger.info("Enabling pinmux bypass with one RW1T command")
        try:
            self._write_one(
                REGISTERS["CMD_REG"], CMD_SET_PINMUX_BP, side_effecting=True
            )
        except AmbiguousCommandError as exc:
            command = self._read_one(REGISTERS["CMD_REG"])
            if command & CMD_SET_PINMUX_BP:
                self.logger.warning("Pinmux write response was lost, but the toggle took effect")
                return
            raise InfrastructureError(
                "pinmux toggle write was ambiguous and the pinmux remains disabled; not retrying"
            ) from exc

    @staticmethod
    def _validate_pointer(value: int, label: str) -> int:
        if value & ~0x1FF:
            raise InfrastructureError(f"{label} contains bits outside its 9-bit field: 0x{value:04X}")
        return value

    def _preflight(self) -> None:
        status = self._read_one(REGISTERS["STATUS_REG"])
        self.logger.info("Modbus communication verified; STATUS=0x%04X", status)
        self._wait_idle()
        self._ensure_pinmux()
        self.logger.info("Clearing stale host-clearable status, errors, and mismatch counters")
        self._write_one(REGISTERS["STATUS_REG"], STATUS_CLEAR_MASK)
        self._write_one(REGISTERS["ERROR_REG"], ERROR_CLEAR_MASK)
        self.transport.write_registers(
            MISMATCH_REGISTERS["cm"], [0, 0, 0, 0]
        )

        tx_cons = self._validate_pointer(
            self._read_one(REGISTERS["UART_TX_CONS_REG"]), "UART_TX_CONS"
        )
        self._write_one(REGISTERS["UART_TX_PROD_REG"], tx_cons)
        rx_prod = self._validate_pointer(
            self._read_one(REGISTERS["UART_RX_PROD_REG"]), "UART_RX_PROD"
        )
        self._write_one(REGISTERS["UART_RX_CONS_REG"], rx_prod)
        self._rx_start_pointer = rx_prod
        self.logger.info(
            "UART FIFO baseline: TX producer/consumer=0x%03X, RX producer/consumer=0x%03X",
            tx_cons,
            rx_prod,
        )

    def _write_sparse_u32(
        self,
        base: int,
        parsed: ParsedMem,
        *,
        description: str,
    ) -> None:
        if not parsed.explicit_addresses:
            self.logger.info("%s contains no explicit words", description)
            return
        self.logger.info(
            "Writing %s: %d explicit 32-bit words in %d contiguous run(s)",
            description,
            len(parsed.explicit_addresses),
            len(contiguous_runs(parsed.explicit_addresses)),
        )
        for run in contiguous_runs(parsed.explicit_addresses):
            words = [parsed.values[address] for address in run]
            write_register_block(
                self.transport,
                base + 2 * run[0],
                pack_u32_be_halfwords(words),
                logger=self.logger,
                description=f"{description} words 0x{run[0]:X}-0x{run[-1]:X}",
            )

    def _load_core_program(self, core: str, parsed: ParsedMem | None) -> None:
        capacity = CORE_CAPACITIES[core]
        words, fallback = build_dense_program(
            parsed,
            capacity,
            fill_unused_with_nops=FILL_UNUSED_PROGMEM_WITH_NOPS,
        )
        program_base, length_register = PROGRAM_REGISTERS[core]
        if fallback:
            self.logger.warning(
                "%s program file missing; using proven two-word empty/self-loop program",
                core.upper(),
            )
        explicit = set(range(2)) if fallback else parsed.explicit_addresses
        filled = set(range(len(words))) - set(explicit)
        fill_label = "NOP (0xFFFFFFFF)"
        self.logger.info(
            "%s PROGMEM fill mode: %s; write length=%d/%d words; filled ranges=%s",
            core.upper(),
            "full deterministic" if FILL_UNUSED_PROGMEM_WITH_NOPS else "compact simulation",
            len(words),
            capacity,
            _format_ranges(filled),
        )
        if filled:
            self.logger.debug("%s unspecified ranges use %s", core.upper(), fill_label)
        write_register_block(
            self.transport,
            program_base,
            pack_u32_be_halfwords(words),
            logger=self.logger,
            description=f"PROGMEM_{core.upper()} ({len(words)} x 32-bit words)",
        )
        self._write_one(length_register, len(words))

    def _load_shared_program(self, parsed: ParsedMem | None) -> None:
        mask_base = REGISTERS["PROGMEM_SHD_MASK"]
        self.logger.info("Clearing complete PROGMEM_SHD mask")
        self.transport.write_registers(mask_base, [0] * 4)
        if parsed is None:
            self.logger.info("Shared program file missing; shared data window remains untouched")
            return
        self._write_sparse_u32(
            REGISTERS["PROGMEM_SHD"], parsed, description="shared program preload"
        )
        mask = build_sparse_mask(parsed.explicit_addresses, MEMORY_CAPACITIES["shd"])
        self.transport.write_registers(mask_base, mask)

    def _load_check(self, section: str, parsed: ParsedMem | None) -> None:
        mask_count = MASK_REGISTER_COUNTS[section]
        mask_base = CHECK_MASK_REGISTERS[section]
        write_register_block(
            self.transport,
            mask_base,
            [0] * mask_count,
            logger=self.logger,
            description=f"clear complete CHKMEM_{section.upper()} mask",
        )
        if parsed is None:
            self.logger.info(
                "%s check file missing; data window remains untouched and check is disabled",
                section.upper(),
            )
            return
        self._write_sparse_u32(
            CHECK_DATA_REGISTERS[section], parsed, description=f"CHKMEM_{section.upper()} expected data"
        )
        mask = build_sparse_mask(parsed.explicit_addresses, MEMORY_CAPACITIES[section])
        write_register_block(
            self.transport,
            mask_base,
            mask,
            logger=self.logger,
            description=f"derived {section.upper()} check mask",
        )

    def _load_gpio(self, inputs: TestInputs) -> None:
        self._gpio = normalize_gpio(inputs.gpio_in, inputs.gpio_out_check)
        if self._gpio.length:
            write_register_block(
                self.transport,
                REGISTERS["GPIO_INPUT_BUFFER"],
                self._gpio.inputs,
                logger=self.logger,
                description="GPIO input buffer",
            )
            write_register_block(
                self.transport,
                REGISTERS["GPIO_OUTPUT_CHK_BUFFER"],
                self._gpio.expected_outputs,
                logger=self.logger,
                description="GPIO expected-output buffer",
            )
        else:
            self.logger.info("No explicit GPIO samples; GPIO data windows remain untouched")
        # Bits 14:8 (mismatch count) are explicitly zero and bits 6:0 hold length.
        self._write_one(REGISTERS["GPIO_PATTERN_REG"], self._gpio.length)
        self.logger.info("GPIO pattern length=%d sample(s)", self._gpio.length)

    def _read_u16_mapping(self, base: int, indices: Iterable[int], description: str) -> dict[int, int]:
        values: dict[int, int] = {}
        runs = contiguous_runs(indices)
        if runs:
            self.logger.info("Reading %s in %d contiguous run(s)", description, len(runs))
        for run in runs:
            words = read_register_block(
                self.transport,
                base + run[0],
                len(run),
                logger=self.logger,
                description=f"{description} registers {run[0]}-{run[-1]}",
            )
            values.update(zip(run, words))
        return values

    def _write_u16_mapping(self, base: int, values: Mapping[int, int], description: str) -> None:
        runs = contiguous_runs(values)
        if values:
            self.logger.info("Writing %s in %d contiguous run(s)", description, len(runs))
        for run in runs:
            write_register_block(
                self.transport,
                base + run[0],
                [values[index] for index in run],
                logger=self.logger,
                description=f"{description} registers {run[0]}-{run[-1]}",
            )

    def _write_uart_tx(self, data: bytes | None) -> None:
        tx_cons = self._validate_pointer(
            self._read_one(REGISTERS["UART_TX_CONS_REG"]), "UART_TX_CONS"
        )
        if data is None or len(data) == 0:
            self._write_one(REGISTERS["UART_TX_PROD_REG"], tx_cons)
            self.logger.info("UART TX input is %s; no buffer data written", "missing" if data is None else "empty")
            return

        lanes: dict[int, set[int]] = {}
        for offset in range(len(data)):
            register_index, shift = uart_byte_location(ring_advance(tx_cons, offset))
            lanes.setdefault(register_index, set()).add(shift)
        partial_indices = [index for index, shifts in lanes.items() if len(shifts) == 1]
        existing = self._read_u16_mapping(
            REGISTERS["UART_TX_BUFFER"], partial_indices, "partial UART TX lanes"
        )
        packed = overlay_uart_bytes(tx_cons, data, existing)
        self._write_u16_mapping(REGISTERS["UART_TX_BUFFER"], packed, "UART TX buffer")
        tx_prod = ring_advance(tx_cons, len(data))
        self._write_one(REGISTERS["UART_TX_PROD_REG"], tx_prod)
        self.logger.info(
            "UART TX loaded: %d bytes, pointer 0x%03X -> 0x%03X, data=%s",
            len(data),
            tx_cons,
            tx_prod,
            describe_bytes(data),
        )

    def _load_all(self, inputs: TestInputs) -> None:
        for core in CORE_CAPACITIES:
            self._load_core_program(core, getattr(inputs, f"{core}_program"))
        self._load_shared_program(inputs.shd_program)
        for section in MEMORY_CAPACITIES:
            self._load_check(section, getattr(inputs, f"{section}_check"))
        self._load_gpio(inputs)
        if inputs.uart_tx is None or len(inputs.uart_tx) == 0:
            self._write_uart_tx(inputs.uart_tx)

    def _start_test(self) -> None:
        self.logger.info("Issuing CMD_REG.TEST_LOAD_RUN")
        try:
            self._write_one(
                REGISTERS["CMD_REG"], CMD_TEST_LOAD_RUN, side_effecting=True
            )
            return
        except AmbiguousCommandError as first_error:
            self.logger.warning("TEST_LOAD_RUN response was ambiguous; inspecting status")
            for _ in range(2):
                status = self._read_one(REGISTERS["STATUS_REG"])
                if status & (STATUS_TEST_RUNNING | STATUS_TEST_DONE):
                    self.logger.warning(
                        "Status 0x%04X proves TEST_LOAD_RUN was accepted; command not retried",
                        status,
                    )
                    return
                self._sleep()
            self.logger.warning("Status remained idle after ambiguous command; retrying once")
            try:
                self._write_one(
                    REGISTERS["CMD_REG"], CMD_TEST_LOAD_RUN, side_effecting=True
                )
                return
            except AmbiguousCommandError as second_error:
                status = self._read_one(REGISTERS["STATUS_REG"])
                if status & (STATUS_TEST_RUNNING | STATUS_TEST_DONE):
                    return
                raise InfrastructureError(
                    "TEST_LOAD_RUN remained ambiguous after one status-guarded retry"
                ) from second_error

    def _force_stop(self, result: TestResult) -> None:
        self.logger.warning("Issuing one-shot CMD_REG.FORCE_STOP")
        try:
            self._write_one(REGISTERS["CMD_REG"], CMD_FORCE_STOP, side_effecting=True)
        except AmbiguousCommandError as exc:
            result.errors.append(f"FORCE_STOP response was ambiguous: {exc}")
        deadline = time.monotonic() + min(5.0, max(1.0, self.timeout))
        while time.monotonic() < deadline:
            status = self._read_one(REGISTERS["STATUS_REG"])
            if not status & STATUS_TEST_RUNNING:
                return
            self._sleep()
        result.errors.append("tester did not stop within the bounded FORCE_STOP wait")

    def _wait_for_completion(
        self,
        result: TestResult,
        uart_tx: bytes | None,
    ) -> int:
        deadline = time.monotonic() + self.timeout
        observed_running = False
        uart_tx_loaded = uart_tx is None or len(uart_tx) == 0
        last_status = 0
        while True:
            last_status = self._read_one(REGISTERS["STATUS_REG"])
            observed_running |= bool(last_status & STATUS_TEST_RUNNING)
            self.logger.debug("Test status poll: 0x%04X", last_status)
            if (
                not uart_tx_loaded
                and (last_status & STATUS_TEST_RUNNING)
                and not (last_status & STATUS_PROGMEM_LOADING)
                and (last_status & 0x0010)
            ):
                self.logger.info(
                    "Programming completed and core execution is active; loading UART TX data"
                )
                self._write_uart_tx(uart_tx)
                uart_tx_loaded = True
            if (last_status & STATUS_TEST_DONE) and not (last_status & STATUS_TEST_RUNNING):
                if not uart_tx_loaded:
                    result.errors.append(
                        "test completed before UART TX data could be loaded after programming"
                    )
                result.test_completed = True
                self.logger.info(
                    "Test completed%s; STATUS=0x%04X",
                    " after TEST_RUNNING" if observed_running else " before TEST_RUNNING was observed",
                    last_status,
                )
                return last_status
            if time.monotonic() >= deadline:
                result.errors.append(f"test timeout after {self.timeout:g} seconds")
                self._force_stop(result)
                return self._read_one(REGISTERS["STATUS_REG"])
            self._sleep()

    def _settle_uart_rx(self, result: TestResult) -> int:
        deadline = time.monotonic() + self.uart_settle_timeout
        previous = self._validate_pointer(
            self._read_one(REGISTERS["UART_RX_PROD_REG"]), "UART_RX_PROD"
        )
        stable_transitions = 0
        while stable_transitions < 2:
            if time.monotonic() >= deadline:
                result.errors.append(
                    f"UART RX producer did not settle within {self.uart_settle_timeout:g} seconds"
                )
                return previous
            self._sleep()
            current = self._validate_pointer(
                self._read_one(REGISTERS["UART_RX_PROD_REG"]), "UART_RX_PROD"
            )
            if current == previous:
                stable_transitions += 1
            else:
                stable_transitions = 0
                previous = current
        return previous

    def _collect_uart(self, final_pointer: int, result: TestResult) -> bytes:
        count = ring_distance(final_pointer, self._rx_start_pointer)
        if count > UART_CAPACITY_BYTES:
            result.errors.append(
                f"UART RX pointer distance {count} exceeds the 256-byte ring capacity"
            )
            count = UART_CAPACITY_BYTES
        register_indices = {
            uart_byte_location(ring_advance(self._rx_start_pointer, offset))[0]
            for offset in range(count)
        }
        registers = self._read_u16_mapping(
            REGISTERS["UART_RX_BUFFER"], register_indices, "UART RX buffer"
        )
        actual = extract_uart_bytes(self._rx_start_pointer, count, registers)
        self._write_one(REGISTERS["UART_RX_CONS_REG"], final_pointer)
        self.logger.info("UART RX captured: %d bytes, data=%s", len(actual), describe_bytes(actual))
        return actual

    @staticmethod
    def _add_once(result: TestResult, message: str) -> None:
        if message not in result.errors:
            result.errors.append(message)

    def _normal_results(
        self,
        inputs: TestInputs,
        result: TestResult,
        status: int,
    ) -> tuple[int, int]:
        if result.test_completed:
            final_rx_prod = self._settle_uart_rx(result)
        else:
            final_rx_prod = self._validate_pointer(
                self._read_one(REGISTERS["UART_RX_PROD_REG"]), "UART_RX_PROD"
            )
        result.uart_actual = self._collect_uart(final_rx_prod, result)

        status = self._read_one(REGISTERS["STATUS_REG"])
        error = self._read_one(REGISTERS["ERROR_REG"])
        gpio_register = self._read_one(REGISTERS["GPIO_PATTERN_REG"])
        mismatch_values = self.transport.read_registers(MISMATCH_REGISTERS["cm"], 4)
        if len(mismatch_values) != 4:
            raise InfrastructureError("malformed four-register mismatch response")
        for section, count in zip(MEMORY_CAPACITIES, mismatch_values):
            result.mismatch_counts[section] = count
            if count:
                self._add_once(result, f"{section.upper()} CHKMEM mismatches: {count}")
        gpio_count = (gpio_register >> 8) & 0x7F
        result.mismatch_counts["gpio"] = gpio_count
        if gpio_count:
            self._add_once(result, f"GPIO mismatches: {gpio_count}")

        for bit, message in (
            (ERROR_PROGRAM_ERROR, "hardware PROGRAM_ERROR is set"),
            (ERROR_MEMRW_ERROR, "hardware MEMRW_ERROR is set"),
            (ERROR_UART_RX_OVERFLOW, "hardware UART_RX_OVERFLOW is set"),
            (ERROR_UART_TX_OVERFLOW, "hardware UART_TX_OVERFLOW is set"),
        ):
            if error & bit:
                self._add_once(result, message)
        if status & STATUS_ERROR_FLAG and not error:
            result.warnings.append("STATUS.ERROR_FLAG is set but ERROR_REG has no decoded failure bits")

        expected = inputs.uart_rx_expected
        if expected is None:
            self.logger.info("UART RX expected: no file (zero bytes required)")
        else:
            self.logger.info(
                "UART RX expected: %d bytes, data=%s", len(expected), describe_bytes(expected)
            )
        self.logger.info(
            "UART RX actual: %d bytes, data=%s",
            len(result.uart_actual),
            describe_bytes(result.uart_actual),
        )
        if expected is None:
            if result.uart_actual:
                self._add_once(
                    result, f"unexpected RX string: {escaped_bytes(result.uart_actual)}"
                )
        elif result.uart_actual != expected:
            self._add_once(
                result,
                f"UART RX mismatch: expected {escaped_bytes(expected)}, got "
                f"{escaped_bytes(result.uart_actual)}",
            )

        self.logger.info("Final STATUS=0x%04X ERROR=0x%04X", status, error)
        self.logger.info(
            "Mismatch counts: CM=%d CT=%d A0=%d SHD=%d GPIO=%d",
            *(result.mismatch_counts[name] for name in ("cm", "ct", "a0", "shd", "gpio")),
        )
        return status, error

    def _wait_for_actmem(self, result: TestResult) -> bool:
        self.logger.info("Issuing CMD_REG.FETCH_ACTMEM (debug mode)")
        ambiguous = False
        try:
            self._write_one(REGISTERS["CMD_REG"], CMD_FETCH_ACTMEM, side_effecting=True)
        except AmbiguousCommandError as exc:
            ambiguous = True
            result.warnings.append(f"FETCH_ACTMEM response was ambiguous: {exc}")

        deadline = time.monotonic() + self.timeout
        observed_fetch = False
        idle_polls = 0
        while time.monotonic() < deadline:
            status = self._read_one(REGISTERS["STATUS_REG"])
            if status & STATUS_ACTMEM_FETCHING:
                observed_fetch = True
                idle_polls = 0
            elif not status & STATUS_BUSY_MASK:
                idle_polls += 1
                if observed_fetch or idle_polls >= 2:
                    if ambiguous and not observed_fetch:
                        result.warnings.append(
                            "FETCH_ACTMEM acceptance could not be observed; treating the fast idle state as completion"
                        )
                    error = self._read_one(REGISTERS["ERROR_REG"])
                    if error & ERROR_PROGRAM_ERROR:
                        self._add_once(result, "PROGRAM_ERROR occurred during FETCH_ACTMEM")
                        return False
                    return True
            self._sleep()
        self._add_once(result, f"debug ACTMEM fetch timeout after {self.timeout:g} seconds")
        return False

    @staticmethod
    def _write_mem_dump(path: Path, words: Sequence[int]) -> None:
        lines = ["@00000000", *(f"{word:08X}" for word in words)]
        path.write_text("\n".join(lines) + "\n", encoding="ascii")

    def _write_memory_diff(
        self,
        section: str,
        parsed: ParsedMem | None,
        actual: Sequence[int],
        output_dir: Path,
        result: TestResult,
    ) -> None:
        expected_values = {} if parsed is None else parsed.values
        explicit = set() if parsed is None else parsed.explicit_addresses
        differences = [
            address for address in sorted(explicit) if expected_values[address] != actual[address]
        ]
        hardware_count = result.mismatch_counts[section]
        if len(differences) != hardware_count:
            self._add_once(
                result,
                f"{section.upper()} hardware/software mismatch-count inconsistency: "
                f"hardware={hardware_count}, software={len(differences)}",
            )
        if not differences:
            return
        path = output_dir / f"{result.test_name}_{section}_diff.txt"
        lines = []
        for address in differences:
            if section == "shd":
                lines.append(
                    f"address=0x{address + 0x2000:04X} index=0x{address:04X} "
                    f"expected=0x{expected_values[address]:08X} actual=0x{actual[address]:08X}"
                )
            else:
                lines.append(
                    f"address=0x{address:04X} expected=0x{expected_values[address]:08X} "
                    f"actual=0x{actual[address]:08X}"
                )
        path.write_text("\n".join(lines) + "\n", encoding="ascii")
        result.artifacts.append(path)
        self.logger.info("Created debug artifact %s", path)

    def _write_gpio_diff(self, output_dir: Path, result: TestResult) -> None:
        if not result.mismatch_counts["gpio"] or not self._gpio.length:
            return
        actual = read_register_block(
            self.transport,
            REGISTERS["GPIO_OUTPUT_ACT_BUFFER"],
            self._gpio.length,
            logger=self.logger,
            description="valid GPIO actual-output buffer",
        )
        lines = ["index expected actual"]
        lines.extend(
            f"{index} 0x{expected:03X} 0x{got:03X}"
            for index, (expected, got) in enumerate(zip(self._gpio.expected_outputs, actual))
            if expected != got
        )
        path = output_dir / f"{result.test_name}_gpio_diff.txt"
        path.write_text("\n".join(lines) + "\n", encoding="ascii")
        result.artifacts.append(path)
        self.logger.info("Created debug artifact %s", path)

    def _write_uart_diff(self, output_dir: Path, result: TestResult) -> None:
        expected = result.uart_expected or b""
        actual = result.uart_actual
        if expected == actual:
            return
        common = min(len(expected), len(actual))
        first_difference = next(
            (index for index in range(common) if expected[index] != actual[index]), common
        )
        lines = [
            f"first_differing_offset={first_difference}",
            f"expected_length={len(expected)}",
            f"actual_length={len(actual)}",
            f"expected_escaped={escaped_bytes(expected)}",
            f"actual_escaped={escaped_bytes(actual)}",
            f"expected_hex={expected.hex()}",
            f"actual_hex={actual.hex()}",
        ]
        path = output_dir / f"{result.test_name}_uart_rx_diff.txt"
        path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        result.artifacts.append(path)
        self.logger.info("Created debug artifact %s", path)

    def _debug_collect(self, inputs: TestInputs, output_dir: Path, result: TestResult) -> None:
        if not result.test_completed:
            result.warnings.append("debug ACTMEM collection skipped because the test did not complete")
            return
        if not self._wait_for_actmem(result):
            result.warnings.append("debug ACTMEM collection is incomplete")
            return

        actual_by_section: dict[str, list[int]] = {}
        for section, capacity in MEMORY_CAPACITIES.items():
            halves = read_register_block(
                self.transport,
                ACTUAL_REGISTERS[section],
                capacity * 2,
                logger=self.logger,
                description=f"full ACTMEM_{section.upper()}",
            )
            words = unpack_u32_be_halfwords(halves)
            actual_by_section[section] = words
            dump_path = output_dir / f"{inputs.name}_{section}_act.mem"
            self._write_mem_dump(dump_path, words)
            result.artifacts.append(dump_path)
            self.logger.info("Created debug artifact %s", dump_path)

        for section in MEMORY_CAPACITIES:
            self._write_memory_diff(
                section,
                getattr(inputs, f"{section}_check"),
                actual_by_section[section],
                output_dir,
                result,
            )
        self._write_gpio_diff(output_dir, result)
        self._write_uart_diff(output_dir, result)

    def run(self, inputs: TestInputs, output_dir: Path) -> TestResult:
        started_wall = iso_now()
        started = time.monotonic()
        result = TestResult(
            test_name=inputs.name,
            mode=self.mode,
            result="FAIL",
            start_time=started_wall,
            end_time=started_wall,
            duration_seconds=0.0,
            uart_device=self.uart_device,
            uart_expected=inputs.uart_rx_expected,
            warnings=list(inputs.warnings),
        )
        self.logger.info("Starting test %s in %s mode", inputs.name, self.mode)
        self._preflight()
        self._load_all(inputs)
        self._start_test()
        status = self._wait_for_completion(result, inputs.uart_tx)
        self._normal_results(inputs, result, status)
        if self.mode == "debug":
            self._debug_collect(inputs, output_dir, result)
        result.result = "PASS" if not result.errors else "FAIL"
        result.end_time = iso_now()
        result.duration_seconds = time.monotonic() - started
        self.logger.info("RESULT: %s", result.result)
        for error in result.errors:
            self.logger.error(error)
        return result
