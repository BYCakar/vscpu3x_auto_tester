"""Output-directory, logging, and JSON report helpers."""

from __future__ import annotations

from collections.abc import Mapping
from datetime import datetime, timezone
import json
import logging
from pathlib import Path

from .models import TestResult


def local_timestamp() -> str:
    return datetime.now().astimezone().strftime("%Y%m%d_%H%M%S")


def iso_now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat()


def create_unique_directory(parent: Path, stem: str) -> Path:
    parent.mkdir(parents=True, exist_ok=True)
    candidate = parent / stem
    suffix = 1
    while candidate.exists():
        candidate = parent / f"{stem}_{suffix}"
        suffix += 1
    candidate.mkdir()
    return candidate


def create_test_output_directory(run_root: Path, test_name: str) -> Path:
    return create_unique_directory(run_root, f"{test_name}_{local_timestamp()}")


def create_suite_output_directory(run_root: Path) -> Path:
    return create_unique_directory(run_root, f"all_{local_timestamp()}")


def configure_test_logger(test_name: str, output_dir: Path, *, verbose: bool = False) -> logging.Logger:
    logger = logging.getLogger(f"vscpu3x_autotester.{test_name}.{output_dir.name}")
    logger.setLevel(logging.DEBUG)
    logger.propagate = False
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")

    file_handler = logging.FileHandler(output_dir / "run.log", encoding="utf-8")
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.DEBUG if verbose else logging.INFO)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    return logger


def close_logger(logger: logging.Logger) -> None:
    for handler in list(logger.handlers):
        handler.flush()
        handler.close()
        logger.removeHandler(handler)


def escaped_bytes(data: bytes) -> str:
    return repr(data)


def describe_bytes(data: bytes) -> str:
    """Return an escaped byte representation plus UTF-8 text when valid."""

    try:
        decoded = data.decode("utf-8")
    except UnicodeDecodeError:
        return f"{escaped_bytes(data)}; hex={data.hex()}"
    return f"{escaped_bytes(data)}; utf-8={json.dumps(decoded, ensure_ascii=False)}"


def result_as_dict(result: TestResult, output_dir: Path | None = None) -> dict:
    def artifact_name(path: Path) -> str:
        if output_dir is not None:
            try:
                return str(path.relative_to(output_dir))
            except ValueError:
                pass
        return str(path)

    expected = result.uart_expected
    return {
        "test_name": result.test_name,
        "mode": result.mode,
        "result": result.result,
        "start_time": result.start_time,
        "end_time": result.end_time,
        "duration_seconds": round(result.duration_seconds, 6),
        "uart_device": result.uart_device,
        "mismatch_counts": dict(result.mismatch_counts),
        "uart": {
            "expected_present": expected is not None,
            "expected_length": 0 if expected is None else len(expected),
            "actual_length": len(result.uart_actual),
            "match": (result.uart_actual == (expected or b"")),
            "expected_escaped": escaped_bytes(expected or b""),
            "actual_escaped": escaped_bytes(result.uart_actual),
            "expected_hex": (expected or b"").hex(),
            "actual_hex": result.uart_actual.hex(),
        },
        "test_completed": result.test_completed,
        "infrastructure_failure": result.infrastructure_failure,
        "errors": list(result.errors),
        "warnings": list(result.warnings),
        "artifacts": [artifact_name(path) for path in result.artifacts],
    }


def write_result_json(
    result: TestResult,
    output_dir: Path,
    *,
    extra_sections: Mapping[str, object] | None = None,
) -> Path:
    path = output_dir / "result.json"
    payload = result_as_dict(result, output_dir)
    if extra_sections:
        overlap = payload.keys() & extra_sections.keys()
        if overlap:
            names = ", ".join(sorted(overlap))
            raise ValueError(f"extra result sections replace standard fields: {names}")
        payload.update(extra_sections)
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return path


def write_suite_summary(
    suite_dir: Path,
    results: list[tuple[TestResult, Path]],
    *,
    start_time: str,
    end_time: str,
) -> None:
    passed = sum(result.passed for result, _ in results)
    summary = {
        "result": "PASS" if passed == len(results) else "FAIL",
        "start_time": start_time,
        "end_time": end_time,
        "selected_count": len(results),
        "passed_count": passed,
        "failed_count": len(results) - passed,
        "tests": [
            {
                "test_name": result.test_name,
                "result": result.result,
                "output_directory": str(output_dir),
                "errors": result.errors,
                "warnings": result.warnings,
            }
            for result, output_dir in results
        ],
    }
    (suite_dir / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    lines = [
        f"VSCPU3x suite result: {summary['result']}",
        f"Started: {start_time}",
        f"Ended:   {end_time}",
        f"Passed: {passed}/{len(results)}",
        "",
    ]
    for result, output_dir in results:
        lines.append(f"{result.test_name}: {result.result} ({output_dir})")
        lines.extend(f"  ERROR: {error}" for error in result.errors)
    (suite_dir / "summary.log").write_text("\n".join(lines) + "\n", encoding="utf-8")
