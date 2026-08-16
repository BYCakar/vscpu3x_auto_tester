"""Pure data preparation helpers used by the hardware runner and unit tests."""

from __future__ import annotations

from collections.abc import Iterable, Mapping, Sequence

from .constants import (
    DEFAULT_BUFFER_WORD,
    GPIO_MAX_PATTERN_LENGTH,
    GPIO_MAX_VALUE,
    IDLE_LOOP_PROGRAM,
    PROGMEM_NOP_WORD,
    UART_POINTER_MASK,
)
from .mem_parser import ParsedMem
from .models import GpioPattern


def pack_u32_be_halfwords(words: Iterable[int]) -> list[int]:
    packed: list[int] = []
    for word in words:
        if not 0 <= word <= 0xFFFFFFFF:
            raise ValueError(f"32-bit word is out of range: {word!r}")
        packed.extend(((word >> 16) & 0xFFFF, word & 0xFFFF))
    return packed


def unpack_u32_be_halfwords(registers: Sequence[int]) -> list[int]:
    if len(registers) % 2:
        raise ValueError("an even number of 16-bit registers is required")
    return [
        (registers[index] << 16) | registers[index + 1]
        for index in range(0, len(registers), 2)
    ]


def build_sparse_mask(addresses: Iterable[int], bit_count: int) -> list[int]:
    """Build physical Modbus mask registers for the checked-out RTL.

    The RTL stores masks as 32-bit words and exposes each through the same
    big-endian halfword mapping as other 32-bit memories. Consequently source
    bit 0 is in the low halfword at ``base + 1``. This preserves the proven
    bubble runner/RTL packing where it conflicts with the rev2 document's
    direct 16-bit mask pseudocode.
    """

    if bit_count < 0:
        raise ValueError("bit_count must not be negative")
    mask32 = [0] * ((bit_count + 31) // 32)
    for address in addresses:
        if not 0 <= address < bit_count:
            raise ValueError(f"mask address {address} is outside 0..{bit_count - 1}")
        mask32[address // 32] |= 1 << (address % 32)
    return pack_u32_be_halfwords(mask32)


def build_dense_program(
    parsed: ParsedMem | None,
    capacity: int,
    *,
    fill_unused_with_nops: bool,
) -> tuple[list[int], bool]:
    """Return the loaded program and whether the two-word fallback was used."""

    fallback = parsed is None
    if parsed is not None and not parsed.explicit_addresses:
        raise ValueError("a present core program file must contain at least one data word")
    values = dict(enumerate(IDLE_LOOP_PROGRAM)) if fallback else parsed.values
    compact_length = max(values) + 1
    if compact_length > capacity:
        raise ValueError(f"program requires {compact_length} words; capacity is {capacity}")
    write_length = capacity if fill_unused_with_nops else compact_length
    fill = PROGMEM_NOP_WORD
    return [values.get(index, fill) for index in range(write_length)], fallback


def normalize_gpio(
    gpio_in: ParsedMem | None,
    gpio_out: ParsedMem | None,
) -> GpioPattern:
    input_addresses = set() if gpio_in is None else gpio_in.explicit_addresses
    output_addresses = set() if gpio_out is None else gpio_out.explicit_addresses
    for label, parsed in (("GPIO input", gpio_in), ("GPIO output check", gpio_out)):
        if parsed is None:
            continue
        for address, value in parsed.values.items():
            if value > GPIO_MAX_VALUE:
                raise ValueError(
                    f"{label} value at address 0x{address:X} exceeds 11 bits: 0x{value:X}"
                )

    last_in = max(input_addresses, default=-1)
    last_out = max(output_addresses, default=-1)
    length = max(last_in, last_out) + 1
    if length > GPIO_MAX_PATTERN_LENGTH:
        raise ValueError(
            f"GPIO pattern length {length} exceeds the representable maximum "
            f"of {GPIO_MAX_PATTERN_LENGTH}"
        )
    if length == 0:
        return GpioPattern(0, [], [], [])

    warnings: list[str] = []
    if input_addresses and min(input_addresses) > 0:
        warnings.append("GPIO input starts above address 0; leading samples are zero-filled")
    if output_addresses and min(output_addresses) > 0:
        warnings.append("GPIO output check starts above address 0; leading samples are zero-filled")
    input_length = last_in + 1
    output_length = last_out + 1
    if input_length != output_length:
        warnings.append(
            f"GPIO input/output effective lengths differ ({input_length} versus {output_length}); "
            "the shorter buffer is zero-filled"
        )
    if gpio_in is None and output_addresses:
        warnings.append("GPIO input file is missing; input samples are zero-filled")
    if gpio_out is None and input_addresses:
        warnings.append("GPIO output-check file is missing; expected samples are zero-filled")

    input_values = {} if gpio_in is None else gpio_in.values
    output_values = {} if gpio_out is None else gpio_out.values
    missing_in = [index for index in range(length) if index not in input_addresses]
    missing_out = [index for index in range(length) if index not in output_addresses]
    if missing_in and input_addresses:
        warnings.append("sparse GPIO input gaps are zero-filled")
    if missing_out and output_addresses:
        warnings.append("sparse GPIO output-check gaps are zero-filled")

    return GpioPattern(
        length=length,
        inputs=[input_values.get(index, DEFAULT_BUFFER_WORD) for index in range(length)],
        expected_outputs=[
            output_values.get(index, DEFAULT_BUFFER_WORD) for index in range(length)
        ],
        warnings=warnings,
    )


def ring_advance(pointer: int, count: int) -> int:
    if not 0 <= pointer <= UART_POINTER_MASK:
        raise ValueError(f"UART pointer is outside 9-bit range: {pointer!r}")
    if not 0 <= count <= 256:
        raise ValueError(f"UART byte count is outside 0..256: {count!r}")
    return (pointer + count) & UART_POINTER_MASK


def ring_distance(end_pointer: int, start_pointer: int) -> int:
    if not 0 <= end_pointer <= UART_POINTER_MASK:
        raise ValueError(f"UART end pointer is outside 9-bit range: {end_pointer!r}")
    if not 0 <= start_pointer <= UART_POINTER_MASK:
        raise ValueError(f"UART start pointer is outside 9-bit range: {start_pointer!r}")
    return (end_pointer - start_pointer) & UART_POINTER_MASK


def uart_byte_location(pointer: int) -> tuple[int, int]:
    """Return ``(buffer register index, shift)`` for a 9-bit UART pointer.

    The checked-out RTL serves even byte slots from bits 15:8 and odd slots
    from bits 7:0, matching the established UART buffer convention.
    """

    slot = pointer & 0xFF
    return slot // 2, 8 if (slot % 2) == 0 else 0


def overlay_uart_bytes(
    start_pointer: int,
    data: bytes,
    existing_registers: Mapping[int, int] | None = None,
) -> dict[int, int]:
    """Pack bytes into circular UART registers while preserving untouched lanes."""

    if len(data) > 256:
        raise ValueError("UART data is longer than 256 bytes")
    existing = {} if existing_registers is None else dict(existing_registers)
    touched_lanes: dict[int, dict[int, int]] = {}
    for offset, byte in enumerate(data):
        register_index, shift = uart_byte_location(ring_advance(start_pointer, offset))
        touched_lanes.setdefault(register_index, {})[shift] = byte

    packed: dict[int, int] = {}
    for register_index, lanes in touched_lanes.items():
        if len(lanes) == 2:
            value = 0
        else:
            if register_index not in existing:
                raise ValueError(
                    f"existing register {register_index} is required to preserve its untouched lane"
                )
            value = existing[register_index]
        for shift, byte in lanes.items():
            value = (value & ~(0xFF << shift)) | (byte << shift)
        packed[register_index] = value
    return packed


def extract_uart_bytes(
    start_pointer: int,
    count: int,
    registers: Mapping[int, int],
) -> bytes:
    if not 0 <= count <= 256:
        raise ValueError("UART byte count is outside 0..256")
    result = bytearray()
    for offset in range(count):
        register_index, shift = uart_byte_location(ring_advance(start_pointer, offset))
        if register_index not in registers:
            raise ValueError(f"UART register {register_index} was not supplied")
        result.append((registers[register_index] >> shift) & 0xFF)
    return bytes(result)


def contiguous_runs(addresses: Iterable[int]) -> list[list[int]]:
    ordered = sorted(set(addresses))
    if not ordered:
        return []
    runs = [[ordered[0]]]
    for address in ordered[1:]:
        if address == runs[-1][-1] + 1:
            runs[-1].append(address)
        else:
            runs.append([address])
    return runs
