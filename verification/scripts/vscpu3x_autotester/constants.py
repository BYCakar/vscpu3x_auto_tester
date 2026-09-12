"""Register map and protocol constants for the VSCPU3x auto tester."""

from __future__ import annotations

PROGMEM_NOP_WORD = 0xFFFFFFFF
DEFAULT_BUFFER_WORD = 0x00000000

# Keep False for RTL simulation. Change this source constant for deterministic
# full-capacity FPGA/hardware loading; it intentionally is not a CLI option.
FILL_UNUSED_PROGMEM_WITH_NOPS = False
MODBUS_BLOCK_REGISTERS = 64

DEFAULT_BAUD_RATE = 115200
DEFAULT_DEVICE_ID = 1
DEFAULT_MODBUS_TIMEOUT_SECONDS = 60.0
DEFAULT_TEST_TIMEOUT_SECONDS = 60.0
DEFAULT_POLL_INTERVAL_SECONDS = 0.2
DEFAULT_UART_SETTLE_TIMEOUT_SECONDS = 3.0
NORMAL_TRANSACTION_ATTEMPTS = 3

SIM_TEST_SUCCESS = 0x0000
SIM_TEST_FAILURE = 0x0001

UART_CAPACITY_BYTES = 256
UART_POINTER_MASK = 0x1FF
GPIO_MAX_VALUE = 0x7FF
GPIO_MAX_PATTERN_LENGTH = 127

CORE_CAPACITIES = {"cm": 2048, "ct": 2560, "a0": 1536}
MEMORY_CAPACITIES = {**CORE_CAPACITIES, "shd": 64}
IDLE_LOOP_PROGRAM = (0x00000000, 0xD0000001)

REGISTERS = {
    "CMD_REG": 0x0000,
    "STATUS_REG": 0x0001,
    "ERROR_REG": 0x0002,
    "TEST_NUM_REG": 0x0003,
    "UART_TX_PROD_REG": 0x0004,
    "UART_TX_CONS_REG": 0x0005,
    "UART_RX_PROD_REG": 0x0006,
    "UART_RX_CONS_REG": 0x0007,
    "GPIO_PATTERN_REG": 0x0008,
    "PROG_CM_PROGLEN_REG": 0x0009,
    "PROG_CT_PROGLEN_REG": 0x000A,
    "PROG_A0_PROGLEN_REG": 0x000B,
    "MEMRW_DATALO_REG": 0x000C,
    "MEMRW_DATAHI_REG": 0x000D,
    "MEMRW_CONTROL_REG": 0x000E,
    "MEMRW_ADDR_REG": 0x000E,
    "SIM_TEST_FINISH_REG": 0x0010,
    "UART_TX_BUFFER": 0x0100,
    "UART_RX_BUFFER": 0x0180,
    "GPIO_INPUT_BUFFER": 0x0200,
    "GPIO_OUTPUT_CHK_BUFFER": 0x0280,
    "GPIO_OUTPUT_ACT_BUFFER": 0x0300,
    "PROGMEM_CM": 0x4000,
    "PROGMEM_CT": 0x5000,
    "PROGMEM_A0": 0x7000,
    "PROGMEM_SHD": 0x7C00,
    "PROGMEM_SHD_MASK": 0x7F80,
    "CHKMEM_CM": 0x8000,
    "CHKMEM_CT": 0x9000,
    "CHKMEM_A0": 0xB000,
    "CHKMEM_SHD": 0xBC00,
    "CHKMEM_CM_MASK": 0xBE00,
    "CHKMEM_CT_MASK": 0xBE80,
    # The rev2 runner document lists 0xBF20/0xBF80 here. The checked-out
    # not_even_dev RTL and its proven modbus_regspace_api.py instead decode
    # 0xBF80/0xBFE0. Preserve the working register map as required by the
    # specification's reference-conflict rule.
    "CHKMEM_A0_MASK": 0xBF80,
    "CHKMEM_SHD_MASK": 0xBFE0,
    "ACTMEM_CM": 0xC000,
    "ACTMEM_CT": 0xD000,
    "ACTMEM_A0": 0xF000,
    "ACTMEM_SHD": 0xFC00,
    "CHKMEM_CM_MISMATCH_REG": 0xFFFC,
    "CHKMEM_CT_MISMATCH_REG": 0xFFFD,
    "CHKMEM_A0_MISMATCH_REG": 0xFFFE,
    "CHKMEM_SHD_MISMATCH_REG": 0xFFFF,
}

PROGRAM_REGISTERS = {
    core: (REGISTERS[f"PROGMEM_{core.upper()}"], REGISTERS[f"PROG_{core.upper()}_PROGLEN_REG"])
    for core in CORE_CAPACITIES
}
CHECK_DATA_REGISTERS = {
    section: REGISTERS[f"CHKMEM_{section.upper()}"] for section in MEMORY_CAPACITIES
}
CHECK_MASK_REGISTERS = {
    section: REGISTERS[f"CHKMEM_{section.upper()}_MASK"] for section in MEMORY_CAPACITIES
}
ACTUAL_REGISTERS = {
    section: REGISTERS[f"ACTMEM_{section.upper()}"] for section in MEMORY_CAPACITIES
}
MISMATCH_REGISTERS = {
    section: REGISTERS[f"CHKMEM_{section.upper()}_MISMATCH_REG"]
    for section in MEMORY_CAPACITIES
}
MASK_REGISTER_COUNTS = {
    section: (capacity + 15) // 16 for section, capacity in MEMORY_CAPACITIES.items()
}

CMD_SET_PINMUX_BP = 1 << 15
CMD_FETCH_ACTMEM = 1 << 4
CMD_FORCE_STOP = 1 << 2
CMD_TEST_LOAD_RUN = 1 << 1

STATUS_ERROR_FLAG = 1 << 15
STATUS_MEMRW_DONE = 1 << 11
STATUS_TEST_DONE = 1 << 8
STATUS_TEST_RUNNING = 1 << 7
STATUS_PROGMEM_LOADING = 1 << 3
STATUS_ACTMEM_FETCHING = 1 << 2
STATUS_PROGMEM_FETCHING = 1 << 1
STATUS_BUSY_MASK = (
    STATUS_TEST_RUNNING
    | STATUS_PROGMEM_LOADING
    | STATUS_ACTMEM_FETCHING
    | STATUS_PROGMEM_FETCHING
)

ERROR_MEMRW_ERROR = 1 << 8
ERROR_UART_RX_OVERFLOW = 1 << 7
ERROR_UART_TX_OVERFLOW = 1 << 6
ERROR_PROGRAM_ERROR = 1 << 5
ERROR_GPIO_MISMATCH = 1 << 4

STATUS_CLEAR_MASK = STATUS_TEST_DONE | STATUS_MEMRW_DONE
ERROR_CLEAR_MASK = ERROR_PROGRAM_ERROR | ERROR_MEMRW_ERROR

MEMRW_VALID = 1 << 15
MEMRW_WEN = 1 << 14
MEMRW_SELECTOR_SHIFT = 12
MEMRW_SELECTOR_MASK = 0x3 << MEMRW_SELECTOR_SHIFT
MEMRW_ADDRESS_MASK = 0x0FFF
MEMRW_SELECTORS = {"cm": 1, "ct": 2, "a0": 3}
MEMRW_BLOCK_WORDS = 512
MEMRW_MAIN_START = 0xE00
MEMRW_MAIN_END = 0xE3D
MEMRW_GPIO_OUT_ADDRESS = 0xE3E
MEMRW_GPIO_IN_ADDRESS = 0xE3F

RECOGNIZED_SUFFIXES = {
    "cm_program": "_cm.mem",
    "ct_program": "_ct.mem",
    "a0_program": "_a0.mem",
    "shd_program": "_shd.mem",
    "cm_check": "_cm_chk.mem",
    "ct_check": "_ct_chk.mem",
    "a0_check": "_a0_chk.mem",
    "shd_check": "_shd_chk.mem",
    "gpio_in": "_gpio_in.mem",
    "gpio_out_check": "_gpio_out_chk.mem",
    "uart_tx": "_uart_tx_buf.txt",
    "uart_rx_expected": "_uart_rx_buf.txt",
}
