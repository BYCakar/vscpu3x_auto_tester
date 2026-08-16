"""PyModbus compatibility adapter and bounded block transaction helpers."""

from __future__ import annotations

from collections.abc import Sequence
import inspect
import logging
import time

from .constants import (
    DEFAULT_BAUD_RATE,
    DEFAULT_DEVICE_ID,
    DEFAULT_MODBUS_TIMEOUT_SECONDS,
    MODBUS_BLOCK_REGISTERS,
    NORMAL_TRANSACTION_ATTEMPTS,
)


class InfrastructureError(RuntimeError):
    """A transport or repository failure that may invalidate further tests."""


class AmbiguousCommandError(InfrastructureError):
    """A side-effecting write failed without proving whether it was accepted."""


class PymodbusTransport:
    def __init__(
        self,
        uart_device: str,
        *,
        baudrate: int = DEFAULT_BAUD_RATE,
        device_id: int = DEFAULT_DEVICE_ID,
        timeout: float = DEFAULT_MODBUS_TIMEOUT_SECONDS,
        logger: logging.Logger | None = None,
    ) -> None:
        try:
            try:
                from pymodbus.client import ModbusSerialClient
            except ImportError:
                from pymodbus.client.sync import ModbusSerialClient
        except ImportError as exc:
            raise InfrastructureError(
                'PyModbus serial support is required; install "pymodbus[serial]"'
            ) from exc

        self.uart_device = uart_device
        self.device_id = device_id
        self.logger = logger or logging.getLogger(__name__)
        self._client = ModbusSerialClient(
            port=uart_device,
            baudrate=baudrate,
            parity="N",
            stopbits=1,
            bytesize=8,
            timeout=timeout,
            retries=0,
        )
        try:
            connected = self._client.connect()
        except Exception as exc:
            self._client.close()
            raise InfrastructureError(
                f"could not open Modbus RTU device {uart_device!r}: {exc}"
            ) from exc
        if not connected:
            self._client.close()
            raise InfrastructureError(f"could not open Modbus RTU device {uart_device!r}")

    def close(self) -> None:
        self._client.close()

    def set_logger(self, logger: logging.Logger) -> None:
        self.logger = logger

    def _device_keyword(self, method) -> dict[str, int]:
        parameters = inspect.signature(method).parameters
        if "device_id" in parameters:
            return {"device_id": self.device_id}
        if "slave" in parameters:
            return {"slave": self.device_id}
        return {"unit": self.device_id}

    @staticmethod
    def _validate_range(address: int, count: int) -> None:
        if count < 1 or address < 0 or address + count - 1 > 0xFFFF:
            raise ValueError(f"invalid Modbus range address=0x{address:X}, count={count}")

    @staticmethod
    def _check_response(response, operation: str):
        if response is None:
            raise InfrastructureError(f"no response while {operation}")
        if response.isError():
            raise InfrastructureError(f"Modbus error response while {operation}: {response}")
        return response

    def _read_once(self, address: int, count: int) -> list[int]:
        method = self._client.read_holding_registers
        response = method(
            address=address,
            count=count,
            **self._device_keyword(method),
        )
        response = self._check_response(response, f"reading {count} register(s) at 0x{address:04X}")
        registers = getattr(response, "registers", None)
        if registers is None or len(registers) != count:
            actual = 0 if registers is None else len(registers)
            raise InfrastructureError(
                f"expected {count} register(s) at 0x{address:04X}, received {actual}"
            )
        return [int(value) for value in registers]

    def read_registers(self, address: int, count: int = 1) -> list[int]:
        self._validate_range(address, count)
        last_error: Exception | None = None
        for attempt in range(1, NORMAL_TRANSACTION_ATTEMPTS + 1):
            try:
                return self._read_once(address, count)
            except Exception as exc:
                last_error = exc
                self.logger.warning(
                    "Read attempt %d/%d failed at 0x%04X (%d registers): %s",
                    attempt,
                    NORMAL_TRANSACTION_ATTEMPTS,
                    address,
                    count,
                    exc,
                )
                if attempt < NORMAL_TRANSACTION_ATTEMPTS:
                    time.sleep(0.05)
        raise InfrastructureError(
            f"read failed at 0x{address:04X} after {NORMAL_TRANSACTION_ATTEMPTS} attempts: "
            f"{last_error}"
        ) from last_error

    def _write_once(self, address: int, values: Sequence[int]) -> None:
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
                values=list(values),
                **self._device_keyword(method),
            )
        self._check_response(response, f"writing {len(values)} register(s) at 0x{address:04X}")

    def write_registers(
        self,
        address: int,
        values: Sequence[int],
        *,
        side_effecting: bool = False,
    ) -> None:
        if not values:
            return
        self._validate_range(address, len(values))
        normalized = list(values)
        if any(not isinstance(value, int) or not 0 <= value <= 0xFFFF for value in normalized):
            raise ValueError("all Modbus values must be 16-bit integers")
        attempts = 1 if side_effecting else NORMAL_TRANSACTION_ATTEMPTS
        last_error: Exception | None = None
        for attempt in range(1, attempts + 1):
            try:
                self._write_once(address, normalized)
                return
            except Exception as exc:
                last_error = exc
                self.logger.warning(
                    "Write attempt %d/%d failed at 0x%04X (%d registers): %s",
                    attempt,
                    attempts,
                    address,
                    len(normalized),
                    exc,
                )
                if attempt < attempts:
                    time.sleep(0.05)
        message = f"write failed at 0x{address:04X} ({len(normalized)} registers): {last_error}"
        if side_effecting:
            raise AmbiguousCommandError(message) from last_error
        raise InfrastructureError(message) from last_error


def read_register_block(
    transport,
    base: int,
    count: int,
    *,
    logger: logging.Logger,
    description: str,
) -> list[int]:
    if count == 0:
        return []
    logger.info("Reading %s: %d x 16-bit registers", description, count)
    values: list[int] = []
    for offset in range(0, count, MODBUS_BLOCK_REGISTERS):
        chunk_count = min(MODBUS_BLOCK_REGISTERS, count - offset)
        values.extend(transport.read_registers(base + offset, chunk_count))
    return values


def write_register_block(
    transport,
    base: int,
    values: Sequence[int],
    *,
    logger: logging.Logger,
    description: str,
) -> None:
    if not values:
        return
    logger.info("Writing %s: %d x 16-bit registers", description, len(values))
    for offset in range(0, len(values), MODBUS_BLOCK_REGISTERS):
        chunk = values[offset : offset + MODBUS_BLOCK_REGISTERS]
        transport.write_registers(base + offset, chunk)
