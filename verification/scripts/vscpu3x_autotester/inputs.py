"""Test discovery and pre-hardware input loading."""

from __future__ import annotations

from pathlib import Path
import subprocess
import sys

from .constants import CORE_CAPACITIES, MEMORY_CAPACITIES, RECOGNIZED_SUFFIXES
from .data import normalize_gpio
from .mem_parser import MemParseError, parse_verilog_mem
from .models import TestInputs


class ConfigurationError(ValueError):
    """A test cannot safely be loaded into hardware."""


GENERATOR_TIMEOUT_SECONDS = 300.0


def validate_test_directory(source_root: Path, test_name: str) -> Path:
    if (
        not test_name
        or test_name == "all"
        or Path(test_name).is_absolute()
        or Path(test_name).name != test_name
        or test_name in {".", ".."}
    ):
        raise ConfigurationError(f"invalid test_name: {test_name}")
    candidate = source_root / test_name
    try:
        root_resolved = source_root.resolve(strict=True)
        resolved = candidate.resolve(strict=True)
    except OSError as exc:
        raise ConfigurationError(f"invalid test_name: {test_name}") from exc
    if not candidate.is_dir() or resolved.parent != root_resolved:
        raise ConfigurationError(f"invalid test_name: {test_name}")
    return resolved


def discover_tests(source_root: Path) -> list[str]:
    if not source_root.is_dir():
        raise ConfigurationError(f"application source directory does not exist: {source_root}")
    root_resolved = source_root.resolve()
    names = []
    for child in source_root.iterdir():
        if child.name.startswith(".") or not child.is_dir():
            continue
        try:
            if child.resolve().parent != root_resolved:
                continue
        except OSError:
            continue
        names.append(child.name)
    names.sort()
    if not names:
        raise ConfigurationError(f"no valid test directories found under {source_root}")
    return names


def prepare_test_inputs(
    test_root: Path, test_name: str, *, use_generated: bool = False
) -> TestInputs:
    """Select, optionally generate, and load one test's runnable artifacts.

    Pregenerated inputs are the default.  When generated inputs are requested,
    ``generate.py`` is run before the Modbus connection is opened.  A missing
    generator causes a warning and a fallback to ``pregenerated``.
    """

    generator = test_root / "generate.py"
    generation_output = ""
    fallback_warning = ""
    generated = use_generated and generator.is_file()
    if generated:
        try:
            completed = subprocess.run(
                [sys.executable, str(generator)],
                cwd=test_root,
                text=True,
                encoding="utf-8",
                errors="replace",
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
                timeout=GENERATOR_TIMEOUT_SECONDS,
            )
        except subprocess.TimeoutExpired as exc:
            raise ConfigurationError(
                f"{generator} exceeded the {GENERATOR_TIMEOUT_SECONDS:g}-second "
                "generation timeout"
            ) from exc
        except OSError as exc:
            raise ConfigurationError(f"could not run {generator}: {exc}") from exc
        if completed.returncode != 0:
            details = "\n".join(
                part.strip()
                for part in (completed.stdout, completed.stderr)
                if part.strip()
            )
            suffix = f"\n{details}" if details else ""
            raise ConfigurationError(
                f"{generator} exited with status {completed.returncode}{suffix}"
            )
        generation_output = "\n".join(
            part.strip()
            for part in (completed.stdout, completed.stderr)
            if part.strip()
        )
        input_root = test_root / "generated"
    else:
        input_root = test_root / "pregenerated"
        if use_generated:
            fallback_warning = (
                f"--generated requested, but {generator} does not exist; "
                "using pregenerated inputs"
            )

    if not input_root.is_dir():
        kind = "generated" if generated else "pregenerated"
        raise ConfigurationError(
            f"{test_root}: {kind} input directory does not exist: {input_root}"
        )
    inputs = load_test_inputs(input_root, test_name)
    inputs.generation_output = generation_output
    if fallback_warning:
        inputs.warnings.insert(0, fallback_warning)
    return inputs


def load_test_inputs(test_root: Path, test_name: str) -> TestInputs:
    expected = {
        field_name: test_root / f"{test_name}{suffix}"
        for field_name, suffix in RECOGNIZED_SUFFIXES.items()
    }
    expected_names = {path.name for path in expected.values()}
    ignored = sorted(
        entry.name
        for entry in test_root.iterdir()
        if not entry.name.startswith(".") and entry.name not in expected_names
    )
    inputs = TestInputs(name=test_name, root=test_root, ignored_files=ignored)

    for field_name, path in expected.items():
        if not path.is_file():
            inputs.missing_files.append(path.name)
            continue
        inputs.recognized_files.append(path.name)
        try:
            if field_name in {"uart_tx", "uart_rx_expected"}:
                value = path.read_bytes()
                if field_name == "uart_tx" and len(value) > 256:
                    raise ConfigurationError(
                        f"{path}: UART TX input is {len(value)} bytes; maximum is 256"
                    )
            else:
                if field_name.startswith("gpio_"):
                    capacity = 128
                elif field_name.startswith("shd_"):
                    capacity = MEMORY_CAPACITIES["shd"]
                else:
                    core = field_name.split("_", 1)[0]
                    capacity = CORE_CAPACITIES[core]
                value = parse_verilog_mem(path, capacity=capacity)
                inputs.warnings.extend(value.warnings)
                if field_name.endswith("_program") and field_name != "shd_program":
                    if not value.explicit_addresses:
                        raise ConfigurationError(f"{path}: core program file is empty")
            setattr(inputs, field_name, value)
        except (OSError, MemParseError) as exc:
            raise ConfigurationError(str(exc)) from exc

    try:
        gpio = normalize_gpio(inputs.gpio_in, inputs.gpio_out_check)
    except ValueError as exc:
        raise ConfigurationError(str(exc)) from exc
    inputs.warnings.extend(gpio.warnings)
    if ignored:
        inputs.warnings.append("ignored unrecognized entries: " + ", ".join(ignored))
    return inputs
