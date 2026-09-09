"""Data models shared by parser, loader, runner, and reporting code."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

from .mem_parser import ParsedMem


@dataclass
class TestInputs:
    name: str
    root: Path
    cm_program: ParsedMem | None = None
    ct_program: ParsedMem | None = None
    a0_program: ParsedMem | None = None
    shd_program: ParsedMem | None = None
    cm_check: ParsedMem | None = None
    ct_check: ParsedMem | None = None
    a0_check: ParsedMem | None = None
    shd_check: ParsedMem | None = None
    gpio_in: ParsedMem | None = None
    gpio_out_check: ParsedMem | None = None
    uart_tx: bytes | None = None
    uart_rx_expected: bytes | None = None
    recognized_files: list[str] = field(default_factory=list)
    missing_files: list[str] = field(default_factory=list)
    ignored_files: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    generation_output: str = ""


@dataclass
class GpioPattern:
    length: int
    inputs: list[int]
    expected_outputs: list[int]
    warnings: list[str] = field(default_factory=list)


@dataclass
class TestResult:
    test_name: str
    mode: str
    result: str
    start_time: str
    end_time: str
    duration_seconds: float
    uart_device: str
    mismatch_counts: dict[str, int] = field(
        default_factory=lambda: {"cm": 0, "ct": 0, "a0": 0, "shd": 0, "gpio": 0}
    )
    uart_expected: bytes | None = None
    uart_actual: bytes = b""
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    artifacts: list[Path] = field(default_factory=list)
    infrastructure_failure: bool = False
    test_completed: bool = False

    @property
    def passed(self) -> bool:
        return self.result == "PASS"
