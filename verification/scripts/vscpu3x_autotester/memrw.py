"""Destructive host-side SRAM and main-memory test through MEMRW.

The MEMRW interface is deliberately exercised one word at a time.  Each
selected word receives a reproducible random 32-bit value and is read back
immediately.  Immediate readback keeps every physical-memory access
self-contained, including regions whose numeric address ranges overlap under
different core selectors.
"""

from __future__ import annotations

from dataclasses import dataclass, field
import logging
import random
import secrets
import time

from .constants import (
    CMD_SET_PINMUX_BP,
    DEFAULT_POLL_INTERVAL_SECONDS,
    DEFAULT_TEST_TIMEOUT_SECONDS,
    ERROR_MEMRW_ERROR,
    MEMRW_ADDRESS_MASK,
    MEMRW_BLOCK_WORDS,
    MEMRW_MAIN_END,
    MEMRW_MAIN_START,
    MEMRW_SELECTORS,
    MEMRW_SELECTOR_SHIFT,
    MEMRW_VALID,
    MEMRW_WEN,
    REGISTERS,
    STATUS_BUSY_MASK,
    STATUS_MEMRW_DONE,
)
from .modbus_transport import AmbiguousCommandError, InfrastructureError
from .report import iso_now


@dataclass(frozen=True)
class MemrwRegion:
    """One independently sampled physical memory region."""

    name: str
    selector: int
    start_address: int
    end_address: int
    kind: str

    @property
    def word_count(self) -> int:
        return self.end_address - self.start_address + 1

    @property
    def addresses(self) -> range:
        return range(self.start_address, self.end_address + 1)


def _make_regions() -> tuple[MemrwRegion, ...]:
    regions: list[MemrwRegion] = []
    for core, block_count in (("cm", 4), ("ct", 5), ("a0", 3)):
        selector = MEMRW_SELECTORS[core]
        for block in range(block_count):
            start = block * MEMRW_BLOCK_WORDS
            regions.append(
                MemrwRegion(
                    name=f"{core}_sram{block}",
                    selector=selector,
                    start_address=start,
                    end_address=start + MEMRW_BLOCK_WORDS - 1,
                    kind="sram",
                )
            )
    # The tester RTL translates this CM-selected range to the command UART's
    # main-memory window.  Keeping the alias CM-specific preserves CT SRAM4,
    # whose physical word range uses the same numeric addresses.
    regions.append(
        MemrwRegion(
            name="main_memory",
            selector=MEMRW_SELECTORS["cm"],
            start_address=MEMRW_MAIN_START,
            end_address=MEMRW_MAIN_END,
            kind="main",
        )
    )
    return tuple(regions)


MEMRW_REGIONS = _make_regions()


@dataclass(frozen=True)
class MemrwAccess:
    region: str
    selector: int
    address: int
    value: int


@dataclass(frozen=True)
class MemrwMismatch:
    region: str
    selector: int
    address: int
    expected: int
    actual: int

    def as_dict(self) -> dict[str, int | str]:
        return {
            "region": self.region,
            "selector": self.selector,
            "address": self.address,
            "expected": self.expected,
            "actual": self.actual,
        }


@dataclass
class MemrwSummary:
    seed: int
    full: bool
    accesses_per_block: int
    start_time: str
    end_time: str = ""
    duration_seconds: float = 0.0
    planned_accesses: int = 0
    attempted_accesses: int = 0
    tested_accesses: int = 0
    transaction_count: int = 0
    completed_transactions: int = 0
    hardware_error_count: int = 0
    timeout_count: int = 0
    region_planned: dict[str, int] = field(default_factory=dict)
    region_tested: dict[str, int] = field(default_factory=dict)
    mismatches: list[MemrwMismatch] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    timed_out: bool = False

    @property
    def mismatch_count(self) -> int:
        return len(self.mismatches)

    @property
    def passed_accesses(self) -> int:
        return self.tested_accesses - self.mismatch_count

    @property
    def completed(self) -> bool:
        return self.attempted_accesses == self.planned_accesses and not self.timed_out

    @property
    def passed(self) -> bool:
        return (
            self.completed
            and self.tested_accesses == self.planned_accesses
            and not self.mismatches
            and not self.errors
        )

    @property
    def result(self) -> str:
        return "PASS" if self.passed else "FAIL"

    def as_dict(self) -> dict[str, object]:
        """Return a JSON-serializable standalone result."""

        return {
            "result": self.result,
            "passed": self.passed,
            "seed": self.seed,
            "full": self.full,
            "accesses_per_block": self.accesses_per_block,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "duration_seconds": round(self.duration_seconds, 6),
            "planned_accesses": self.planned_accesses,
            "attempted_accesses": self.attempted_accesses,
            "tested_accesses": self.tested_accesses,
            "passed_accesses": self.passed_accesses,
            "transaction_count": self.transaction_count,
            "completed_transactions": self.completed_transactions,
            "hardware_error_count": self.hardware_error_count,
            "timeout_count": self.timeout_count,
            "mismatch_count": self.mismatch_count,
            "completed": self.completed,
            "timed_out": self.timed_out,
            "region_planned": dict(self.region_planned),
            "region_tested": dict(self.region_tested),
            "mismatches": [mismatch.as_dict() for mismatch in self.mismatches],
            "errors": list(self.errors),
            "warnings": list(self.warnings),
        }


def _validate_access_count(accesses_per_block: int) -> None:
    if isinstance(accesses_per_block, bool) or not isinstance(accesses_per_block, int):
        raise ValueError("accesses_per_block must be an integer")
    if accesses_per_block <= 0:
        raise ValueError("accesses_per_block must be greater than zero")


def _resolved_seed(seed: int | None) -> int:
    if seed is None:
        return secrets.randbits(64)
    if isinstance(seed, bool) or not isinstance(seed, int):
        raise ValueError("seed must be an integer")
    return seed


def build_memrw_plan(
    accesses_per_block: int,
    *,
    full: bool = False,
    seed: int | None = None,
) -> list[MemrwAccess]:
    """Build a reproducible MEMRW access plan without touching hardware.

    Random-mode counts are capped at the capacity of each individual region.
    Thus a request for 100 accesses samples 100 words from every SRAM block and
    all 62 usable main-memory words.
    """

    _validate_access_count(accesses_per_block)
    rng = random.Random(_resolved_seed(seed))
    plan: list[MemrwAccess] = []
    for region in MEMRW_REGIONS:
        if full:
            addresses = list(region.addresses)
        else:
            count = min(accesses_per_block, region.word_count)
            addresses = rng.sample(region.addresses, count)
        plan.extend(
            MemrwAccess(
                region=region.name,
                selector=region.selector,
                address=address,
                value=rng.getrandbits(32),
            )
            for address in addresses
        )
    return plan


class MemrwTester:
    """Execute a generated MEMRW plan over an existing Modbus transport."""

    def __init__(
        self,
        transport,
        *,
        timeout: float = DEFAULT_TEST_TIMEOUT_SECONDS,
        poll_interval: float = DEFAULT_POLL_INTERVAL_SECONDS,
        logger: logging.Logger | None = None,
    ) -> None:
        if timeout <= 0:
            raise ValueError("timeout must be greater than zero")
        if poll_interval < 0:
            raise ValueError("poll_interval must not be negative")
        self.transport = transport
        self.timeout = timeout
        self.poll_interval = poll_interval
        self.logger = logger or logging.getLogger(__name__)

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
                    "tester remained busy before MEMRW test "
                    f"(STATUS=0x{status:04X})"
                )
            self._sleep()

    def _ensure_pinmux(self) -> None:
        command = self._read_one(REGISTERS["CMD_REG"])
        if command & CMD_SET_PINMUX_BP:
            self.logger.debug("Pinmux bypass is already enabled for MEMRW")
            return
        self.logger.info("Enabling pinmux bypass for MEMRW")
        try:
            self._write_one(
                REGISTERS["CMD_REG"], CMD_SET_PINMUX_BP, side_effecting=True
            )
        except AmbiguousCommandError as exc:
            command = self._read_one(REGISTERS["CMD_REG"])
            if command & CMD_SET_PINMUX_BP:
                self.logger.warning(
                    "Pinmux response was lost, but the bypass toggle took effect"
                )
                return
            raise InfrastructureError(
                "pinmux toggle write was ambiguous and bypass remains disabled; not retrying"
            ) from exc

    def _preflight(self) -> None:
        status = self._wait_idle()
        self.logger.info("Tester is idle before MEMRW; STATUS=0x%04X", status)
        self._ensure_pinmux()
        # Both fields are sticky RW1C.  Establish a clean baseline before the
        # first transaction; subsequent transactions clear DONE individually.
        self._write_one(REGISTERS["STATUS_REG"], STATUS_MEMRW_DONE)
        self._write_one(REGISTERS["ERROR_REG"], ERROR_MEMRW_ERROR)

    def _read_status_and_error(self) -> tuple[int, int]:
        values = self.transport.read_registers(REGISTERS["STATUS_REG"], 2)
        if len(values) != 2:
            raise InfrastructureError(
                "malformed MEMRW status response: expected STATUS and ERROR registers"
            )
        return values[0], values[1]

    def _wait_done(self) -> tuple[bool, int, int]:
        deadline = time.monotonic() + self.timeout
        while True:
            status, error = self._read_status_and_error()
            if status & STATUS_MEMRW_DONE:
                return True, status, error
            if time.monotonic() >= deadline:
                return False, status, error
            self._sleep()

    @staticmethod
    def _access_label(access: MemrwAccess, operation: str) -> str:
        return (
            f"{operation} {access.region} selector={access.selector} "
            f"address=0x{access.address:03X}"
        )

    def _transaction(
        self,
        access: MemrwAccess,
        *,
        write: bool,
        summary: MemrwSummary,
    ) -> tuple[bool, int | None]:
        operation = "write" if write else "read"
        label = self._access_label(access, operation)

        # DONE belongs to the preceding request until explicitly cleared.
        self._write_one(REGISTERS["STATUS_REG"], STATUS_MEMRW_DONE)
        control = (
            MEMRW_VALID
            | (MEMRW_WEN if write else 0)
            | (access.selector << MEMRW_SELECTOR_SHIFT)
            | (access.address & MEMRW_ADDRESS_MASK)
        )
        summary.transaction_count += 1
        try:
            if write:
                # Modbus writes consecutive registers in address order, so the
                # final CONTROL write starts MEMRW only after both data halves
                # have been latched.
                self.transport.write_registers(
                    REGISTERS["MEMRW_DATALO_REG"],
                    [
                        access.value & 0xFFFF,
                        (access.value >> 16) & 0xFFFF,
                        control,
                    ],
                    side_effecting=True,
                )
            else:
                self._write_one(
                    REGISTERS["MEMRW_CONTROL_REG"], control, side_effecting=True
                )
        except AmbiguousCommandError as exc:
            # A completion flag can prove that the one-shot was accepted.  It
            # is never safe to retry a request containing the control write.
            summary.warnings.append(f"ambiguous MEMRW {label} response: {exc}")

        completed, _status, error = self._wait_done()
        if not completed:
            summary.timeout_count += 1
            summary.timed_out = True
            summary.errors.append(
                f"MEMRW {label} timeout after {self.timeout:g} seconds"
            )
            # ERROR was captured alongside the final STATUS poll.  Consume it
            # so a later invocation does not inherit a stale MEMRW failure.
            if error & ERROR_MEMRW_ERROR:
                self._write_one(REGISTERS["ERROR_REG"], ERROR_MEMRW_ERROR)
                summary.hardware_error_count += 1
                summary.errors.append(
                    f"MEMRW {label} timeout also exposed MEMRW_ERROR"
                )
            return False, None

        summary.completed_transactions += 1
        if error & ERROR_MEMRW_ERROR:
            # Clear only the MEMRW RW1C field and leave unrelated sticky errors
            # available to their owning test flow.
            self._write_one(REGISTERS["ERROR_REG"], ERROR_MEMRW_ERROR)
            summary.hardware_error_count += 1
            summary.errors.append(f"MEMRW {label} completed with MEMRW_ERROR")
            return False, None

        if write:
            return True, None

        halves = self.transport.read_registers(REGISTERS["MEMRW_DATALO_REG"], 2)
        if len(halves) != 2:
            raise InfrastructureError(
                "malformed MEMRW data response: expected DATALO and DATAHI registers"
            )
        value = ((halves[1] & 0xFFFF) << 16) | (halves[0] & 0xFFFF)
        return True, value

    def run(
        self,
        *,
        accesses_per_block: int,
        full: bool = False,
        seed: int | None = None,
    ) -> MemrwSummary:
        _validate_access_count(accesses_per_block)
        actual_seed = _resolved_seed(seed)
        plan = build_memrw_plan(
            accesses_per_block,
            full=full,
            seed=actual_seed,
        )
        started = time.monotonic()
        summary = MemrwSummary(
            seed=actual_seed,
            full=full,
            accesses_per_block=accesses_per_block,
            start_time=iso_now(),
        )
        for access in plan:
            summary.region_planned[access.region] = (
                summary.region_planned.get(access.region, 0) + 1
            )
        summary.region_tested = {name: 0 for name in summary.region_planned}
        summary.planned_accesses = len(plan)

        if not full:
            for region in MEMRW_REGIONS:
                if accesses_per_block > region.word_count:
                    summary.warnings.append(
                        f"{region.name} has only {region.word_count} usable words; "
                        f"testing all of them instead of {accesses_per_block}"
                    )

        self.logger.info(
            "Starting MEMRW %s test: seed=%d accesses=%d requested_per_region=%d",
            "full" if full else "random",
            actual_seed,
            len(plan),
            accesses_per_block,
        )
        self._preflight()

        active_region = ""
        for access in plan:
            if access.region != active_region:
                active_region = access.region
                self.logger.info(
                    "Testing MEMRW region %s: %d word(s)",
                    active_region,
                    summary.region_planned[active_region],
                )
            summary.attempted_accesses += 1
            write_ok, _ = self._transaction(access, write=True, summary=summary)
            if summary.timed_out:
                break
            if not write_ok:
                continue

            read_ok, actual = self._transaction(access, write=False, summary=summary)
            if summary.timed_out:
                break
            if not read_ok:
                continue

            assert actual is not None
            summary.tested_accesses += 1
            summary.region_tested[access.region] += 1
            if actual != access.value:
                mismatch = MemrwMismatch(
                    region=access.region,
                    selector=access.selector,
                    address=access.address,
                    expected=access.value,
                    actual=actual,
                )
                summary.mismatches.append(mismatch)
                self.logger.error(
                    "MEMRW mismatch in %s selector=%d address=0x%03X: "
                    "expected=0x%08X actual=0x%08X",
                    mismatch.region,
                    mismatch.selector,
                    mismatch.address,
                    mismatch.expected,
                    mismatch.actual,
                )

        summary.end_time = iso_now()
        summary.duration_seconds = time.monotonic() - started
        self.logger.info(
            "MEMRW RESULT: %s; tested=%d/%d mismatches=%d hardware_errors=%d timeouts=%d",
            summary.result,
            summary.tested_accesses,
            summary.planned_accesses,
            summary.mismatch_count,
            summary.hardware_error_count,
            summary.timeout_count,
        )
        for error in summary.errors:
            self.logger.error(error)
        return summary


def run_memrw_test(
    transport,
    *,
    accesses_per_block: int,
    full: bool = False,
    seed: int | None = None,
    timeout: float = DEFAULT_TEST_TIMEOUT_SECONDS,
    poll_interval: float = DEFAULT_POLL_INTERVAL_SECONDS,
    logger: logging.Logger | None = None,
) -> MemrwSummary:
    """Convenience entry point used by the CLI and unit tests."""

    return MemrwTester(
        transport,
        timeout=timeout,
        poll_interval=poll_interval,
        logger=logger,
    ).run(
        accesses_per_block=accesses_per_block,
        full=full,
        seed=seed,
    )


__all__ = [
    "MEMRW_REGIONS",
    "MemrwAccess",
    "MemrwMismatch",
    "MemrwRegion",
    "MemrwSummary",
    "MemrwTester",
    "build_memrw_plan",
    "run_memrw_test",
]
