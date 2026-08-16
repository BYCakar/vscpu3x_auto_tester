"""Strict, small `$readmemh`-style hexadecimal memory parser."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
import re


class MemParseError(ValueError):
    """Raised when a memory file cannot be represented safely."""


@dataclass
class ParsedMem:
    values: dict[int, int]
    explicit_addresses: set[int]
    warnings: list[str] = field(default_factory=list)


_BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
_HEX_BODY_RE = re.compile(r"[0-9a-fA-F]+(?:_[0-9a-fA-F]+)*")


def _parse_hex(token: str, *, kind: str, path: Path, line_number: int) -> int:
    original = token
    if token.lower().startswith("0x"):
        token = token[2:]
    if not token or not _HEX_BODY_RE.fullmatch(token):
        unknown_like_hex = bool(
            re.fullmatch(r"[0-9a-fA-F_xXzZ]+", token)
            and re.search(r"[xXzZ]", token)
        )
        if unknown_like_hex:
            detail = "unknown x/z digits are not allowed"
        else:
            detail = "malformed hexadecimal token"
        raise MemParseError(
            f"{path}:{line_number}: {detail} in {kind}: {original!r}"
        )
    return int(token.replace("_", ""), 16)


def parse_verilog_mem(path: Path, *, capacity: int | None = None) -> ParsedMem:
    """Parse hexadecimal words and explicit word addresses from *path*.

    ``capacity`` is expressed in 32-bit source words. Every data token marks one
    explicit address; holes introduced by address directives remain implicit.
    """

    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        raise MemParseError(f"could not read {path}: {exc}") from exc

    # Preserve line numbers and keep comments from accidentally joining two
    # otherwise separate hexadecimal tokens.
    text = _BLOCK_COMMENT_RE.sub(
        lambda match: " " + ("\n" * match.group().count("\n")) + " ", text
    )
    values: dict[int, int] = {}
    explicit: set[int] = set()
    warnings: list[str] = []
    current_address = 0

    for line_number, raw_line in enumerate(text.splitlines(), 1):
        line = raw_line.split("//", 1)[0].split("#", 1)[0].strip()
        if not line:
            continue
        for token in line.split():
            if token.startswith("@"):
                address_token = token[1:]
                if not address_token:
                    raise MemParseError(f"{path}:{line_number}: empty address directive")
                if address_token.startswith("-"):
                    raise MemParseError(
                        f"{path}:{line_number}: negative addresses are not allowed: {token!r}"
                    )
                current_address = _parse_hex(
                    address_token, kind="address directive", path=path, line_number=line_number
                )
                if capacity is not None and current_address >= capacity:
                    raise MemParseError(
                        f"{path}:{line_number}: address 0x{current_address:X} is outside "
                        f"the valid word range 0..{capacity - 1}"
                    )
                continue

            value = _parse_hex(token, kind="data", path=path, line_number=line_number)
            if value > 0xFFFFFFFF:
                raise MemParseError(
                    f"{path}:{line_number}: value {token!r} is wider than 32 bits"
                )
            if capacity is not None and current_address >= capacity:
                raise MemParseError(
                    f"{path}:{line_number}: address 0x{current_address:X} is outside "
                    f"the valid word range 0..{capacity - 1}"
                )
            if current_address in explicit:
                warnings.append(
                    f"{path.name}: duplicate address 0x{current_address:08X}; last value wins"
                )
            values[current_address] = value
            explicit.add(current_address)
            current_address += 1

    return ParsedMem(values=values, explicit_addresses=explicit, warnings=warnings)
