import argparse
from pathlib import Path
import time
import modbus_regspace_api as mb

parser = argparse.ArgumentParser(description="Run the CM bubble-sort test.")
parser.add_argument("uart_device", help="Path to UART device, e.g. /dev/ttyUSB0.")
args = parser.parse_args()

UART = args.uart_device
APP = Path("../../../caravel_vscpu3x_board/vscpu3x_apps/bubble_sort").resolve()

CM_PROGMEM_WORDS = 2048
CT_PROGMEM_WORDS = 2560
A0_PROGMEM_WORDS = 1536
FILL_UNUSED_WITH_ONES = False

def base(name):
    return int(mb.REGISTER_MAP[name], 16)

def u32_to_u16s(words):
    out = []
    for w in words:
        out += [f"{(w >> 16) & 0xffff:04x}", f"{w & 0xffff:04x}"]
    return out

def write_many(start_addr, words16, chunk=16):
    for off in range(0, len(words16), chunk):
        mb.write_regs(UART, words16[off:off + chunk], start_addr + off)

def read_sparse_mem(path):
    mem = {}
    addr = 0
    for raw in path.read_text().splitlines():
        line = raw.split("//", 1)[0].split("#", 1)[0].strip()
        if not line:
            continue
        if line.startswith("@"):
            addr = int(line[1:], 0)
            continue
        for tok in line.split():
            mem[addr] = int(tok, 16)
            addr += 1
    return mem

# Enable pinmux if it is currently disabled. CMD_REG[15] is RW1T.
cmd = int(mb.read_regs(UART, "CMD_REG", 2)[0], 16)
if (cmd & 0x8000) == 0:
    mb.write_regs(UART, 0x8000, "CMD_REG")

# Clear sticky DONE / error bits and old mismatch counters.
mb.write_regs(UART, 0x0900, "STATUS_REG")  # MEMRW_DONE + TEST_DONE RW1C
mb.write_regs(UART, 0x0120, "ERROR_REG")   # MEMRW_ERROR + PROGRAM_ERROR RW1C
for reg in ["CHKMEM_CM_MISMATCH_REG", "CHKMEM_CT_MISMATCH_REG",
            "CHKMEM_A0_MISMATCH_REG", "CHKMEM_SHD_MISMATCH_REG"]:
    mb.write_regs(UART, 0x0000, reg)

# Clear all CHKMEM masks so only bubble-sort result addresses are compared.
write_many(base("CHKMEM_CM_MASK"),  ["0000"] * (64 * 2))
write_many(base("CHKMEM_CT_MASK"),  ["0000"] * (80 * 2))
write_many(base("CHKMEM_A0_MASK"),  ["0000"] * (48 * 2))
write_many(base("CHKMEM_SHD_MASK"), ["0000"] * (2 * 2))

# Load sparse CM program densely, optionally filling unused memory with ones.
prog = read_sparse_mem(APP / "bubble_sort_cm.mem")
cm_write_words = CM_PROGMEM_WORDS if FILL_UNUSED_WITH_ONES else max(prog) + 1
cm_words = [prog.get(i, 0xFFFFFFFF if FILL_UNUSED_WITH_ONES else 0)
            for i in range(cm_write_words)]
write_many(base("PROGMEM_CM"), u32_to_u16s(cm_words))
mb.write_regs(UART, CM_PROGMEM_WORDS, "PROG_CM_PROGLEN_REG")

# Give CT/A0 tiny self-loops so TEST_LOAD_RUN can see all cores finish.
idle_loop = [0x00000000, 0xD0000001]  # 0: 0, 0: BZJi 0 1
ct_words = idle_loop.copy()
a0_words = idle_loop.copy()
if FILL_UNUSED_WITH_ONES:
    ct_words += [0xFFFFFFFF] * (CT_PROGMEM_WORDS - len(idle_loop))
    a0_words += [0xFFFFFFFF] * (A0_PROGMEM_WORDS - len(idle_loop))
write_many(base("PROGMEM_CT"), u32_to_u16s(ct_words))
write_many(base("PROGMEM_A0"), u32_to_u16s(a0_words))
mb.write_regs(UART, CT_PROGMEM_WORDS, "PROG_CT_PROGLEN_REG")
mb.write_regs(UART, A0_PROGMEM_WORDS, "PROG_A0_PROGLEN_REG")

# Load expected CM result and create compare mask bits.
chk = read_sparse_mem(APP / "bubble_sort_cm_chk.mem")
for addr, word in chk.items():
    write_many(base("CHKMEM_CM") + 2 * addr, u32_to_u16s([word]))

mask_words = {}
for addr in chk:
    mask_words[addr // 32] = mask_words.get(addr // 32, 0) | (1 << (addr % 32))

for mask_idx, mask in mask_words.items():
    write_many(base("CHKMEM_CM_MASK") + 2 * mask_idx, u32_to_u16s([mask]))

# Load, run, fetch masked ACTMEM, compare.
mb.write_regs(UART, 0x0002, "CMD_REG")  # TEST_LOAD_RUN

while True:
    status = int(mb.read_regs(UART, "STATUS_REG", 2)[0], 16)
    if (status & 0x0100) and not (status & 0x0080):  # TEST_DONE and not TEST_RUNNING
        break
    time.sleep(0.2)

print("STATUS =", mb.read_regs(UART, "STATUS_REG", 2)[0])
print("ERROR  =", mb.read_regs(UART, "ERROR_REG", 2)[0])
print("CM mismatches =", mb.read_regs(UART, "CHKMEM_CM_MISMATCH_REG", 2)[0])

# Optional: read sorted array from ACTMEM_CM[301..310].
halves = mb.read_regs(UART, base("ACTMEM_CM") + 2 * 301, 20)
actual = [int(halves[i] + halves[i + 1], 16) for i in range(0, len(halves), 2)]
print(actual)
