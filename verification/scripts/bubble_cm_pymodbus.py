from __future__ import annotations

import argparse
import inspect
from pathlib import Path
import time
from typing import Sequence, Union

from modbus_regspace_api import REGISTER_MAP

try:
    from pymodbus.client import ModbusSerialClient
except ImportError:
    try:
        # PyModbus 2.x used this import path.
        from pymodbus.client.sync import ModbusSerialClient
    except ImportError as exc:
        raise SystemExit(
            "PyModbus serial support is required. Install it with: "
            'python3 -m pip install "pymodbus[serial]"'
        ) from exc


MODBUS_TIMEOUT_SECONDS = 60
MODBUS_DEVICE_ID = 1
MEMRW_DONE = 0x0800
MEMRW_CM_SHARED_ADDR_0_WRITE = 0xD800
Word = Union[str, int]


class ModbusInterfaceError(RuntimeError):
    """Raised when a PyModbus connection or transaction fails."""


class PymodbusInterface:
    """Small adapter matching the register helper used by bubble_cm.py."""

    REGISTER_MAP = REGISTER_MAP

    def __init__(self, uart_device: str) -> None:
        self._client = ModbusSerialClient(
            port=uart_device,
            baudrate=115200,
            parity="N",
            stopbits=1,
            bytesize=8,
            timeout=MODBUS_TIMEOUT_SECONDS,
            retries=0,
        )

        if not self._client.connect():
            self._client.close()
            raise ModbusInterfaceError(
                f"Could not open Modbus RTU device {uart_device!r}."
            )

    def close(self) -> None:
        self._client.close()

    @staticmethod
    def _address(start_reg: Union[str, int]) -> int:
        if isinstance(start_reg, int):
            address = start_reg
        else:
            address = int(REGISTER_MAP[start_reg], 16)

        if not 0 <= address <= 0xFFFF:
            raise ValueError(f"Modbus register address is out of range: {address!r}")
        return address

    @staticmethod
    def _word(value: Word) -> int:
        if isinstance(value, int):
            word = value
        else:
            word = int(value.strip(), 16)

        if not 0 <= word <= 0xFFFF:
            raise ValueError(f"Modbus register value is out of range: {value!r}")
        return word

    @staticmethod
    def _device_keyword(method) -> dict[str, int]:
        """Handle the slave/device keyword rename across PyModbus releases."""
        parameters = inspect.signature(method).parameters
        if "device_id" in parameters:
            return {"device_id": MODBUS_DEVICE_ID}
        if "slave" in parameters:
            return {"slave": MODBUS_DEVICE_ID}
        return {"unit": MODBUS_DEVICE_ID}

    @staticmethod
    def _check_response(response, operation: str):
        if response is None:
            raise ModbusInterfaceError(f"No response received while {operation}.")
        if response.isError():
            raise ModbusInterfaceError(
                f"Modbus error response while {operation}: {response}"
            )
        return response

    def write_regs(
        self,
        uart_device: str,
        write_data: Union[Word, Sequence[Word]],
        start_reg: Union[str, int],
    ) -> None:
        # uart_device remains in the signature so calls are identical to bubble_cm.py.
        del uart_device
        if isinstance(write_data, (str, int)):
            values = [self._word(write_data)]
        else:
            values = [self._word(value) for value in write_data]

        if not values:
            return

        address = self._address(start_reg)
        if len(values) == 1:
            method = self._client.write_register
            response = method(
                address=address,
                value=values[0],
                **self._device_keyword(method),
            )
        else:
            method = self._client.write_registers
            response = method(
                address=address,
                values=values,
                **self._device_keyword(method),
            )

        self._check_response(response, f"writing {len(values)} register(s) at {address:#06x}")

    def read_regs(
        self,
        uart_device: str,
        start_reg: Union[str, int],
        read_len: int,
    ) -> list[str]:
        # uart_device remains in the signature so calls are identical to bubble_cm.py.
        del uart_device
        if read_len <= 0:
            return []

        address = self._address(start_reg)
        method = self._client.read_holding_registers
        response = method(
            address=address,
            count=read_len,
            **self._device_keyword(method),
        )
        response = self._check_response(
            response, f"reading {read_len} register(s) at {address:#06x}"
        )

        registers = getattr(response, "registers", None)
        if registers is None or len(registers) != read_len:
            actual_len = 0 if registers is None else len(registers)
            raise ModbusInterfaceError(
                f"Expected {read_len} register(s) at {address:#06x}, "
                f"received {actual_len}."
            )
        return [f"{word:04x}" for word in registers]


def base(name: str) -> int:
    return int(REGISTER_MAP[name], 16)


def u32_to_u16s(words: Sequence[int]) -> list[str]:
    out = []
    for word in words:
        out += [f"{(word >> 16) & 0xffff:04x}", f"{word & 0xffff:04x}"]
    return out


def read_sparse_mem(path: Path) -> dict[int, int]:
    mem = {}
    addr = 0
    for raw in path.read_text().splitlines():
        line = raw.split("//", 1)[0].split("#", 1)[0].strip()
        if not line:
            continue
        if line.startswith("@"):
            addr = int(line[1:], 0)
            continue
        for token in line.split():
            mem[addr] = int(token, 16)
            addr += 1
    return mem


def run_bubble_cm(uart_device: str) -> None:
    app = (
        Path(__file__).resolve().parent
        / "../../../caravel_vscpu3x_board/vscpu3x_apps/bubble_sort"
    ).resolve()

    cm_progmem_words = 2048
    ct_progmem_words = 2560
    a0_progmem_words = 1536
    fill_unused_with_ones = False

    mb = PymodbusInterface(uart_device)

    def write_many(start_addr: int, words16: Sequence[Word], chunk: int = 64) -> None:
        for offset in range(0, len(words16), chunk):
            mb.write_regs(
                uart_device,
                words16[offset:offset + chunk],
                start_addr + offset,
            )

    try:
        # Enable pinmux if it is currently disabled. CMD_REG[15] is RW1T.
        cmd = int(mb.read_regs(uart_device, "CMD_REG", 2)[0], 16)
        if (cmd & 0x8000) == 0:
            mb.write_regs(uart_device, 0x8000, "CMD_REG")

        # Clear sticky DONE / error bits and old mismatch counters.
        mb.write_regs(uart_device, 0x0900, "STATUS_REG")
        mb.write_regs(uart_device, 0x0120, "ERROR_REG")

        # Dummy write of 0x00000000 to shared-memory word 0. Selecting CM for
        # the MEMRW transaction asserts program_sel early, which speeds up RTL
        # simulation before TEST_LOAD_RUN begins.
        mb.write_regs(uart_device, [0x0000, 0x0000], "MEMRW_DATALO_REG")
        mb.write_regs(
            uart_device,
            MEMRW_CM_SHARED_ADDR_0_WRITE,
            "MEMRW_ADDR_REG",
        )
        while True:
            status = int(mb.read_regs(uart_device, "STATUS_REG", 2)[0], 16)
            if status & MEMRW_DONE:
                break
            time.sleep(0.01)
        mb.write_regs(uart_device, MEMRW_DONE, "STATUS_REG")

        for reg in [
            "CHKMEM_CM_MISMATCH_REG",
            "CHKMEM_CT_MISMATCH_REG",
            "CHKMEM_A0_MISMATCH_REG",
            "CHKMEM_SHD_MISMATCH_REG",
        ]:
            mb.write_regs(uart_device, 0x0000, reg)

        # Clear all CHKMEM masks so only bubble-sort result addresses are compared.
        write_many(base("CHKMEM_CM_MASK"), ["0000"] * (64 * 2))
        write_many(base("CHKMEM_CT_MASK"), ["0000"] * (80 * 2))
        write_many(base("CHKMEM_A0_MASK"), ["0000"] * (48 * 2))
        write_many(base("CHKMEM_SHD_MASK"), ["0000"] * (2 * 2))

        # Load sparse CM program densely, optionally filling unused memory with ones.
        prog = read_sparse_mem(app / "bubble_sort_cm.mem")
        cm_write_words = cm_progmem_words if fill_unused_with_ones else max(prog) + 1
        cm_words = [
            prog.get(index, 0xFFFFFFFF if fill_unused_with_ones else 0)
            for index in range(cm_write_words)
        ]
        write_many(base("PROGMEM_CM"), u32_to_u16s(cm_words))
        mb.write_regs(uart_device, len(cm_words), "PROG_CM_PROGLEN_REG")

        # Give CT/A0 tiny self-loops so TEST_LOAD_RUN can see all cores finish.
        idle_loop = [0x00000000, 0xD0000001]  # 0: 0, 0: BZJi 0 1
        ct_words = idle_loop.copy()
        a0_words = idle_loop.copy()
        if fill_unused_with_ones:
            ct_words += [0xFFFFFFFF] * (ct_progmem_words - len(idle_loop))
            a0_words += [0xFFFFFFFF] * (a0_progmem_words - len(idle_loop))
        write_many(base("PROGMEM_CT"), u32_to_u16s(ct_words))
        write_many(base("PROGMEM_A0"), u32_to_u16s(a0_words))
        mb.write_regs(uart_device, len(ct_words), "PROG_CT_PROGLEN_REG")
        mb.write_regs(uart_device, len(a0_words), "PROG_A0_PROGLEN_REG")

        # Load expected CM result and create compare mask bits.
        chk = read_sparse_mem(app / "bubble_sort_cm_chk.mem")
        for address, word in chk.items():
            write_many(base("CHKMEM_CM") + 2 * address, u32_to_u16s([word]))

        mask_words = {}
        for address in chk:
            mask_words[address // 32] = (
                mask_words.get(address // 32, 0) | (1 << (address % 32))
            )

        for mask_index, mask in mask_words.items():
            write_many(
                base("CHKMEM_CM_MASK") + 2 * mask_index,
                u32_to_u16s([mask]),
            )

        # Load, run, fetch masked ACTMEM, compare.
        mb.write_regs(uart_device, 0x0002, "CMD_REG")  # TEST_LOAD_RUN

        while True:
            status = int(mb.read_regs(uart_device, "STATUS_REG", 2)[0], 16)
            if (status & 0x0100) and not (status & 0x0080):
                break
            time.sleep(0.2)

        print("STATUS =", mb.read_regs(uart_device, "STATUS_REG", 2)[0])
        print("ERROR  =", mb.read_regs(uart_device, "ERROR_REG", 2)[0])
        print(
            "CM mismatches =",
            mb.read_regs(uart_device, "CHKMEM_CM_MISMATCH_REG", 2)[0],
        )

        # Optional: read sorted array from ACTMEM_CM[301..310].
        halves = mb.read_regs(
            uart_device,
            base("ACTMEM_CM") + 2 * 301,
            20,
        )
        actual = [
            int(halves[index] + halves[index + 1], 16)
            for index in range(0, len(halves), 2)
        ]
        print(actual)
    finally:
        mb.close()


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the CM bubble-sort test.")
    parser.add_argument(
        "uart_device",
        help="Path to UART device, e.g. /dev/ttyUSB0.",
    )
    args = parser.parse_args()
    run_bubble_cm(args.uart_device)


if __name__ == "__main__":
    main()
