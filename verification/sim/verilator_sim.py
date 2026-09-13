#!/usr/bin/env python3
"""Build/run the shared RTL or functional GL testbench with Verilator."""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[2]
SIM_DIR = ROOT / "verification" / "sim"
TB_DIR = ROOT / "verification" / "tb"
FPGA_DIR = ROOT / "design" / "src"
CARAVEL_DIR = ROOT / "caravel_vscpu3x"
RTL_DIR = CARAVEL_DIR / "verilog" / "rtl"
GL_DIR = CARAVEL_DIR / "verilog" / "gl"
PDK_DIR = CARAVEL_DIR / "pdk" / "sky130A" / "libs.ref" / "sky130_fd_sc_hd" / "verilog"

# Match the sources used by compile_sim.tcl. Both backends share the testbench,
# DPI UART, tester RTL, SRAM model, and recorded Caravel submodule checkout.
FPGA_FILES = """
Modbus_Regspace.v modbus_uart_tx.v modbus_uart_rx.v Modbus_UART_Controller.v
fifo.v Modbus_CRC16.v Modbus_Top.v cmd_uart.v cmd_uart_controller.sv test_rom.v
test_driver.v test_controller.v vscpu3x_pinmux.v vscpu3x_auto_tester_top.v
vscpu3x_test_top.v
""".split()
RTL_FILES = """
user_project_wrapper.v parameters.v agent_memory_controller.v
codemaker_memory_controller.v command_processor_memory_controller.v
control_tower_memory_controller.v list_ch04_11_mod_m_counter.v
list_ch04_20_fifo.v list_ch08_01_uart_rx.v list_ch08_03_uart_tx.v list_ch08_04_uart.v
main_controller.v main_memory.v multicore_mem_controller.v Priority_Arbiter.v
reset_circuit.v Round_Robin_Arbiter.v Thermometer_Mask.v uart_cp.v uart_p.v
VerySimpleCPU_core.v VerySimpleCPU.v
""".split()
GL_FILES = """
VerySimpleCPU_core.v main_controller.v main_memory.v uart.v user_project_wrapper.v
""".split()


def switch(name: str) -> bool:
    value = os.environ.get(name, "0")
    if value not in ("0", "1"):
        raise ValueError(f"{name} must be 0 or 1")
    return value == "1"


def verilator_sram(source: Path, build_dir: Path) -> Path:
    """Give the behavioral SRAM's undriven supply ports their input direction.

    Verilator treats these unused inouts as outputs, then rejects the GL
    netlist's constant supply connections. Only the generated copy is changed;
    the SRAM's storage, access timing, and parent submodule remain intact.
    """
    content = source.read_text()
    for pin in ("vccd1", "vssd1"):
        content, count = re.subn(rf"\binout\s+{pin}\s*;", f"input {pin};", content)
        if count != 1:
            raise ValueError(f"Expected one SRAM supply declaration for {pin} in {source}")
    target = build_dir / source.name
    if not target.exists() or target.read_text() != content:
        target.write_text(content)
    return target


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("rtl", "gl"), required=True)
    parser.add_argument("--build-only", action="store_true")
    args = parser.parse_args()
    try:
        if switch("GUI"):
            raise ValueError("Verilator runs in batch mode; use TRACE=1 for a VCD waveform")
        cover, trace = switch("COVER"), switch("TRACE")
        jobs = int(os.environ.get("VERILATOR_JOBS", "4"))
        if jobs < 1:
            raise ValueError("VERILATOR_JOBS must be a positive integer")
        extra_flags = shlex.split(os.environ.get("VERILATOR_FLAGS", ""))
        plusargs = shlex.split(os.environ.get("SIM_PLUSARGS", ""))
        testname = os.environ.get("TESTNAME", "")
        if testname and (Path(testname).name != testname or testname in (".", "..")):
            raise ValueError("TESTNAME must be a directory name under verification/vscpu3x_apps")

        tool = shutil.which(os.environ.get("VERILATOR", "verilator"))
        if tool is None:
            raise ValueError("Verilator not found; install Verilator 5.020 or newer, or set VERILATOR=/path/to/verilator")
        version = subprocess.check_output([tool, "--version"], text=True)
        match = re.search(r"Verilator (\d+)\.(\d+)", version)
        if not match or tuple(map(int, match.groups())) < (5, 20):
            raise ValueError(f"Verilator 5.020 or newer is required; found {version.strip()}")

        sources = [FPGA_DIR / name for name in FPGA_FILES]
        defines = ["-DMPRJ_IO_PADS=38", "-DVSCPU_MEM_FILL_1S"]
        includes = [f"-I{RTL_DIR}", f"-I{FPGA_DIR}"]
        if testname:
            defines.append("-DVSCPU_MEM_INIT")
            prefix = ROOT / "verification" / "vscpu3x_apps" / testname / testname
            plusargs.append(f"+VSCPU_MEM_INIT_FILE_PREFIX={prefix}")
        if args.mode == "gl":
            defines += ["-DUSE_POWER_PINS", "-DFUNCTIONAL", "-DUNIT_DELAY="]
            includes.append(f"-I{PDK_DIR}")
            sources += [SIM_DIR / "verilator_gl.vlt", TB_DIR / "sky130_verilator_primitives.sv",
                        PDK_DIR / "primitives.v", PDK_DIR / "sky130_fd_sc_hd.v"]
            sources += [GL_DIR / name for name in GL_FILES]
        else:
            sources += [RTL_DIR / name for name in RTL_FILES]
        sources += [RTL_DIR / "sky130_sram_2kbyte_1rw1r_32x512_8.v",
                    TB_DIR / "dpi_uart" / "dpi_uart.sv", TB_DIR / "vscpu3x_test_tb.v",
                    TB_DIR / "dpi_uart" / "dpi_uart.cpp", TB_DIR / "verilator_main.cpp"]
        for source in sources:
            if not source.is_file():
                hint = "Run make gl_setup." if source.parent == PDK_DIR else "Initialize the caravel_vscpu3x submodule."
                raise ValueError(f"Missing simulation source: {source}. {hint}")

        build_dir = SIM_DIR / "verilator" / f"{args.mode}-cover{int(cover)}-trace{int(trace)}-init{int(bool(testname))}"
        build_dir.mkdir(parents=True, exist_ok=True)
        if args.mode == "gl":
            sram = RTL_DIR / "sky130_sram_2kbyte_1rw1r_32x512_8.v"
            sources[sources.index(sram)] = verilator_sram(sram, build_dir)
        command = [tool, "--cc", "--exe", "--build", "--timing",
                   "--top-module", "vscpu3x_test_tb", "--prefix", "Vvscpu3x_test_tb",
                   "--Mdir", str(build_dir), "-o", "sim", "-j", str(jobs), "-Wno-fatal"]
        if cover:
            command.append("--coverage")
        if trace:
            command.append("--trace")
        command += defines + includes + extra_flags + [str(source) for source in sources]
        print(shlex.join(command), flush=True)
        subprocess.run(command, cwd=ROOT, check=True)
        executable = build_dir / "sim"
        print(f"Simulation executable: {executable}", flush=True)
        if not args.build_only:
            os.chdir(build_dir)
            os.execv(executable, [str(executable), *plusargs])
        return 0
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"Verilator simulation error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
