from __future__ import annotations

import re
import shlex
import subprocess
from pathlib import Path
from typing import Dict, Iterable, Iterator, List, Mapping, Sequence, Union


THIS_DIR = Path(__file__).resolve().parent
MBPOLL_TIMEOUT_SECONDS = "10"


class ModbusScriptError(RuntimeError):
    """Raised when the Modbus helper script encounters an invalid state."""


# This dictionary is intentionally embedded in the script so the .vh file does
# not need to be parsed at runtime.
REGISTER_ADDR_HEX: Dict[str, str] = {
    "CMD_REG": "0x0000",
    "STATUS_REG": "0x0001",
    "ERROR_REG": "0x0002",
    "TEST_NUM_REG": "0x0003",
    "UART_TX_PROD_REG": "0x0004",
    "UART_TX_CONS_REG": "0x0005",
    "UART_RX_PROD_REG": "0x0006",
    "UART_RX_CONS_REG": "0x0007",
    "GPIO_PATTERN_REG": "0x0008",
    "PROG_CM_PROGLEN_REG": "0x0009",
    "PROG_CT_PROGLEN_REG": "0x000a",
    "PROG_A0_PROGLEN_REG": "0x000b",
    "MEMRW_DATALO_REG": "0x000c",
    "MEMRW_DATAHI_REG": "0x000d",
    "MEMRW_ADDR_REG": "0x000e",
    "SOFT_RESET_REG": "0x000f",
    "UART_TX_BUFFER": "0x0100",
    "UART_RX_BUFFER": "0x0180",
    "GPIO_INPUT_BUFFER": "0x0200",
    "GPIO_OUTPUT_CHK_BUFFER": "0x0280",
    "GPIO_OUTPUT_ACT_BUFFER": "0x0300",
    "PROGMEM_CM": "0x4000",
    "PROGMEM_CT": "0x5000",
    "PROGMEM_A0": "0x7000",
    "PROGMEM_SHD": "0x7c00",
    "PROGMEM_SHD_MASK": "0x7f80",
    "CHKMEM_CM": "0x8000",
    "CHKMEM_CT": "0x9000",
    "CHKMEM_A0": "0xb000",
    "CHKMEM_SHD": "0xbc00",
    "CHKMEM_CM_MASK": "0xbe00",
    "CHKMEM_CT_MASK": "0xbe80",
    "CHKMEM_A0_MASK": "0xbf80",
    "CHKMEM_SHD_MASK": "0xbfe0",
    "ACTMEM_CM": "0xc000",
    "ACTMEM_CT": "0xd000",
    "ACTMEM_A0": "0xf000",
    "ACTMEM_SHD": "0xfc00",
    "CHKMEM_CM_MISMATCH_REG": "0xfffc",
    "CHKMEM_CT_MISMATCH_REG": "0xfffd",
    "CHKMEM_A0_MISMATCH_REG": "0xfffe",
    "CHKMEM_SHD_MISMATCH_REG": "0xffff",
}

REGISTER_ADDR_INT = {name: int(addr, 16) for name, addr in REGISTER_ADDR_HEX.items()}


INDEXED_REGISTER_PATTERN = re.compile(r"^(?P<name>[A-Za-z_][A-Za-z0-9_]*)\[(?P<index>\d+)\]$")


def _resolve_register_expression(expr: str) -> int:
    key = expr.strip()

    if key in REGISTER_ADDR_INT:
        return REGISTER_ADDR_INT[key]

    indexed_match = INDEXED_REGISTER_PATTERN.fullmatch(key)
    if indexed_match:
        base_name = indexed_match.group("name")
        index = int(indexed_match.group("index"))

        if base_name not in REGISTER_ADDR_INT:
            raise ModbusScriptError(
                f"Unknown base register name in indexed expression: {expr!r}"
            )

        # One Modbus register is 16 bits, so NAME[n] means base + n registers.
        # In byte-offset terms this corresponds to base + (2 * n) bytes.
        return REGISTER_ADDR_INT[base_name] + index

    lowered = key.lower()
    if lowered.startswith("0x"):
        return int(lowered, 16)
    if re.fullmatch(r"[0-9a-f]+", lowered):
        return int(lowered, 16)

    raise ModbusScriptError(
        f"Unknown register name/address: {expr!r}. "
        "Use a key from REGISTER_ADDR_HEX, an indexed form like NAME[15], "
        "or provide a hex address."
    )


class RegisterAddressMap(Mapping[str, str]):
    """Dictionary-like register map with dynamic support for NAME[index]."""

    def __init__(self, base_map: Dict[str, str]) -> None:
        self._base_map = dict(base_map)

    def __getitem__(self, key: str) -> str:
        resolved_addr = _resolve_register_expression(key)
        return f"0x{resolved_addr:04x}"

    def __iter__(self) -> Iterator[str]:
        return iter(self._base_map)

    def __len__(self) -> int:
        return len(self._base_map)

    def __contains__(self, key: object) -> bool:
        if not isinstance(key, str):
            return False
        try:
            _resolve_register_expression(key)
            return True
        except ModbusScriptError:
            return False

    def get(self, key: str, default: str | None = None) -> str | None:
        try:
            return self[key]
        except ModbusScriptError:
            return default

    def keys(self):
        return self._base_map.keys()

    def items(self):
        return self._base_map.items()

    def values(self):
        return self._base_map.values()

    def copy(self) -> Dict[str, str]:
        return dict(self._base_map)

REGISTER_MAP = RegisterAddressMap(REGISTER_ADDR_HEX)


def build_register_dict() -> Dict[str, str]:
    """
    Return a copy of the embedded base register-address dictionary.

    The content was generated once from Modbus_Regspace_defines.vh and then
    embedded into this script so runtime parsing is not required.

    For dynamic indexed access such as ACTMEM_A0[15], use REGISTER_MAP
    directly or pass the expression into write_regs/read_regs.
    """
    return dict(REGISTER_ADDR_HEX)


def _normalize_hex_word(value: Union[str, int], width: int = 4) -> str:
    if isinstance(value, int):
        return f"{value:0{width}x}"

    cleaned = value.strip().lower()
    if cleaned.startswith("0x"):
        cleaned = cleaned[2:]
    cleaned = cleaned.replace("_", "")

    if not cleaned:
        raise ModbusScriptError("Encountered an empty hex value.")
    if not re.fullmatch(r"[0-9a-f]+", cleaned):
        raise ModbusScriptError(f"Invalid hex value: {value!r}")

    return cleaned.zfill(width)


def _resolve_register_address(start_reg: Union[str, int]) -> int:
    if isinstance(start_reg, int):
        return start_reg

    return _resolve_register_expression(start_reg)


def _run_mbpoll(args: Sequence[str]) -> str:
    try:
        completed = subprocess.run(
            list(args),
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as exc:
        raise ModbusScriptError("mbpoll executable was not found in PATH.") from exc
    except subprocess.CalledProcessError as exc:
        command = " ".join(shlex.quote(arg) for arg in exc.cmd)
        raise ModbusScriptError(
            f"mbpoll failed with exit code {exc.returncode}.\n"
            f"command:\n{command}\n"
            f"stdout:\n{exc.stdout}\n"
            f"stderr:\n{exc.stderr}"
        ) from exc

    return completed.stdout


def write_regs(
    uart_device: str,
    write_data: Union[str, int, Sequence[Union[str, int]]],
    start_reg: Union[str, int],
) -> None:
    """
    Write one or more 16-bit words into consecutive Modbus registers.

    Parameters
    ----------
    uart_device:
        Device path that will be passed directly to mbpoll.
    write_data:
        A single hex word or a list/tuple of hex words.
    start_reg:
        Register name from REGISTER_ADDR_HEX, an indexed expression like
        ACTMEM_A0[15], or a numeric/hex address.
    """
    if isinstance(write_data, (str, int)):
        values = [_normalize_hex_word(write_data, width=4)]
    else:
        values = [_normalize_hex_word(value, width=4) for value in write_data]

    if not values:
        return

    start_addr = _resolve_register_address(start_reg)

    cmd = [
        "mbpoll",
        "-m",
        "rtu",
        "-b",
        "115200",
        "-P",
        "none",
        "-o",
        MBPOLL_TIMEOUT_SECONDS,
        "-a",
        "0x1",
        "-t",
        "4:hex",
        "-0",
        "-r",
        str(start_addr),
        uart_device,
        *[f"0x{value}" for value in values],
    ]
    _run_mbpoll(cmd)


def _extract_hex_words_from_mbpoll(output: str, expected_count: int) -> List[str]:
    values: List[str] = []
    data_line_pattern = re.compile(
        r"^\s*\[\d+\]\s*:\s*(?:0x)?([0-9a-fA-F]{1,4})\b"
    )

    for line in output.splitlines():
        match = data_line_pattern.match(line)
        if match:
            values.append(match.group(1).lower().zfill(4))

    if len(values) != expected_count:
        raise ModbusScriptError(
            "Could not parse the expected number of words from mbpoll output. "
            f"Expected {expected_count}, parsed {len(values)}.\n"
            f"mbpoll output was:\n{output}"
        )

    return values


def read_regs(
    uart_device: str,
    start_reg: Union[str, int],
    read_len: int,
) -> List[str]:
    """
    Read consecutive 16-bit words from Modbus registers and return them as a
    list of lowercase hex strings without the 0x prefix.

    start_reg may also be an indexed expression such as PROGMEM_A0[6].
    """
    if read_len <= 0:
        return []

    start_addr = _resolve_register_address(start_reg)
    cmd = [
        "mbpoll",
        "-m",
        "rtu",
        "-b",
        "115200",
        "-P",
        "none",
        "-o",
        MBPOLL_TIMEOUT_SECONDS,
        "-a",
        "0x1",
        "-t",
        "4:hex",
        "-0",
        "-c",
        str(read_len),
        "-r",
        str(start_addr),
        "-1",
        uart_device,
    ]
    stdout = _run_mbpoll(cmd)
    return _extract_hex_words_from_mbpoll(stdout, read_len)


def _resolve_program_directory(pgm_name: str) -> Path:
    candidate = Path(pgm_name)
    if candidate.is_dir():
        return candidate.resolve()

    parent_candidate = (Path.cwd() / ".." / pgm_name).resolve()
    if parent_candidate.is_dir():
        return parent_candidate

    raise ModbusScriptError(
        f"Program directory could not be found for {pgm_name!r}. "
        f"Checked {candidate} and {parent_candidate}."
    )


def _read_mem_file(mem_path: Path) -> List[str]:
    words: List[str] = []
    for raw_line in mem_path.read_text().splitlines():
        line = raw_line.strip()
        if not line:
            continue
        if line.startswith("//") or line.startswith("#"):
            continue

        line = line.split("//", 1)[0].strip()
        line = line.split("#", 1)[0].strip()
        if not line:
            continue

        words.append(_normalize_hex_word(line, width=8))

    return words


def _split_u32_words_to_u16_stream(words_32: Iterable[str]) -> List[str]:
    words_16: List[str] = []
    for word in words_32:
        normalized = _normalize_hex_word(word, width=8)
        words_16.append(normalized[:4])
        words_16.append(normalized[4:])
    return words_16


def load_program(uart_device: str, pgm_name: str) -> None:
    """
    Load up to three *.mem files into the PROGMEM areas.

    Expected files inside the program directory:
        <pgm_name>_cm.mem
        <pgm_name>_ct.mem
        <pgm_name>_a0.mem

    For each existing file:
    1. Write the program length register with the number of 32-bit words.
    2. Write program data into the corresponding PROGMEM area as consecutive
       16-bit Modbus register writes, using high half-word first and low
       half-word second. This ordering follows the RTL read mapping where an
       even address maps to bits [31:16] and the odd address maps to bits [15:0].
    """
    program_dir = _resolve_program_directory(pgm_name)
    folder_name = program_dir.name

    core_map = {
        "cm": {
            "mem_file": program_dir / f"{folder_name}_cm.mem",
            "progmem_reg": "PROGMEM_CM",
            "proglen_reg": "PROG_CM_PROGLEN_REG",
        },
        "ct": {
            "mem_file": program_dir / f"{folder_name}_ct.mem",
            "progmem_reg": "PROGMEM_CT",
            "proglen_reg": "PROG_CT_PROGLEN_REG",
        },
        "a0": {
            "mem_file": program_dir / f"{folder_name}_a0.mem",
            "progmem_reg": "PROGMEM_A0",
            "proglen_reg": "PROG_A0_PROGLEN_REG",
        },
    }

    for info in core_map.values():
        mem_path = info["mem_file"]
        if not mem_path.exists():
            continue

        words_32 = _read_mem_file(mem_path)
        program_length = len(words_32)
        write_regs(uart_device, f"{program_length:04x}", info["proglen_reg"])

        if not words_32:
            continue

        words_16 = _split_u32_words_to_u16_stream(words_32)
        write_regs(uart_device, words_16, info["progmem_reg"])


__all__ = [
    "ModbusScriptError",
    "REGISTER_ADDR_HEX",
    "REGISTER_ADDR_INT",
    "REGISTER_MAP",
    "build_register_dict",
    "load_program",
    "read_regs",
    "write_regs",
]
