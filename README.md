# VSCPU3x Auto Tester

The `dev` branch contains an FPGA-based test controller and a Python runner for
loading and checking VSCPU3x applications over Modbus RTU. Tests can provide
program images, expected memory contents, GPIO samples, and UART data. The
runner records a log and a machine-readable result for every run.

## Repository layout

- `design/src/` - synthesizable auto-tester and Modbus RTL
- `vscpu3x_apps/tests/` - static and generated test applications
- `verification/scripts/` - Python command-line runner
- `verification/tb/` - RTL testbench and PTY-backed DPI UART
- `verification/sim/` - Questa/ModelSim compile and waveform scripts
- `caravel_vscpu3x/` - Caravel RTL and gate-level netlists (submodule, `questa_fix` branch)

## Requirements

The command-line runner requires Python 3.10 or newer and PyModbus with serial
support:

```bash
python3 -m pip install "pymodbus[serial]"
```

The target must expose the auto-tester register space through Modbus RTU. The
defaults are 115200 baud, device ID 1, 8 data bits, no parity, and 1 stop bit.
Use the CLI options shown by `--help` if the target uses different settings.

## Running tests

Run commands from the repository root. To execute one of the applications in
`vscpu3x_apps/tests/`, pass its directory name, serial device, and mode:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  cm_standalone /dev/ttyUSB0 run
```

Use `all` to run every application's pregenerated inputs in lexical order while
keeping one Modbus connection open:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py all /dev/ttyUSB0 run
```

Pregenerated inputs are always the default, including for tests that provide a
`generate.py` script. Pass `--generated` to run each available generator and
load its `generated/` output:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  gpio_xor /dev/ttyUSB0 run --generated
```

If `--generated` is requested for a test without `generate.py`, the runner
prints a warning and uses that test's `pregenerated/` inputs. This also applies
to individual tests in an `all --generated` run.

The `debug` mode also fetches the complete actual memories and writes memory,
GPIO, and UART diff artifacts when applicable:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  gpio_xor /dev/ttyUSB0 debug
```

For all available timeout, polling, Modbus, and logging options, run:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py --help
```

The process exits with status 0 when all selected tests pass, 1 for a test
failure, and 2 for invalid configuration or an infrastructure failure. Results
are written to timestamped directories under `vscpu3x_apps/run/`. Each test
produces `run.log` and `result.json`; an `all` run also produces suite-level
`summary.log` and `summary.json` files.

### MEMRW test

`memrw` is a special destructive test that does not load an application. In
random mode, `-n` selects how many distinct 32-bit words are written and read
back in each 2 KiB SRAM block and in shared/main memory:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  memrw /dev/ttyUSB0 run -n 16 --seed 0x1234
```

The seed is optional and is recorded in `result.json`. There are four
Codemaker, five Control Tower, and three Agent 0 SRAM blocks. Shared/main memory
contains 62 testable words; if `n` is greater than 62, that region is capped at
62 and a warning is recorded. Each SRAM block is similarly capped at its 512
distinct word addresses.

Use `--full` to write and read every implemented SRAM and shared/main-memory
word:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  memrw /dev/ttyUSB0 run --full --seed 0x1234
```

Full mode covers 6,206 words. The shared-memory GPIO output and input addresses
are deliberately excluded. `memrw` is not included in an `all` application
run, and its `run` and `debug` modes use the same access/check flow.

## Test application format

Each immediate directory under `vscpu3x_apps/tests/` is a test. Tests store
their default runnable files in `pregenerated/`. A randomized test additionally
provides a no-argument `generate.py`; the runner executes it only when
`--generated` is passed and then loads runnable files from `generated/`.

The complete directory convention is:

```text
vscpu3x_apps/tests/<test_name>/
|-- generate.py             # optional; configuration is edited in this file
|-- pregenerated/           # runnable files for a static test
|-- generated/              # runnable output from generate.py
`-- src/
    |-- ...                 # C files, constant data, and other inputs
    `-- generated/          # generated headers and intermediate sources
```

Generated assembly and generated C/header inputs belong in `src/generated/`;
only files consumed by the auto tester belong in the top-level `generated/`
directory. Generator stdout and stderr are copied into the test's `run.log`,
which lets a generator report its random seed. A failing generator is reported
as a configuration error before any Modbus connection is opened.

Runnable file names must begin with the test directory name. For a test named
`example`, the runner recognizes:

| File | Purpose |
| --- | --- |
| `example_cm.mem` | Codemaker program |
| `example_ct.mem` | Control Tower program |
| `example_a0.mem` | Agent 0 program |
| `example_shd.mem` | Shared-memory preload |
| `example_cm_chk.mem` | Expected Codemaker memory |
| `example_ct_chk.mem` | Expected Control Tower memory |
| `example_a0_chk.mem` | Expected Agent 0 memory |
| `example_shd_chk.mem` | Expected shared memory |
| `example_gpio_in.mem` | GPIO input samples |
| `example_gpio_out_chk.mem` | Expected GPIO output samples |
| `example_uart_tx_buf.txt` | Bytes sent to the VSCPU3x UART |
| `example_uart_rx_buf.txt` | Bytes expected from the VSCPU3x UART |

Memory files use Verilog `$readmemh`-style hexadecimal data and may include
`@address` directives, `//` comments, and `/* ... */` comments. Sparse check
files are supported: only explicitly populated addresses are compared.

A missing core program is replaced with a two-word idle loop, and a missing
memory check file disables that memory check. If only one GPIO file is present,
the missing input or expected-output samples are zero-filled; if both are
absent, GPIO checking is skipped. If the expected UART RX file is absent, the
test expects no UART output. Unrecognized files are ignored and reported as
warnings.

### Randomized GPIO XOR

`gpio_xor/generate.py` selects random 10-bit GPIO samples and a random pattern
length, computes the chained-XOR outputs, generates the C parameters, compiles
the program, and creates the three runnable files in `gpio_xor/generated/`.
Edit `PATTERN_LENGTH_MIN` and `PATTERN_LENGTH_MAX` in the script to control the
inclusive length range; set them equal for a fixed length. `RANDOM_SEED`,
`COMPILER_PATH`, and `ASMTOMEM_PATH` are also editable in the script.

### Randomized Mastermind

`mastermind/generate.py` chooses a base-8 four-digit secret, writes it to a
generated C header, compiles the Codemaker, Control Tower, and Agent 0 sources,
converts their assembly with `asmtomem.py`, clears the shared protocol area, and
generates the exact expected UART transcript. Edit `RANDOM_SEED` for a
reproducible random case or `FIXED_SECRET` for a specific case. The compiler and
converter locations are controlled by `COMPILER_PATH` and `ASM_TO_MEM_PATH` in
the script.

## RTL simulation

RTL simulation requires a 64-bit Questa/ModelSim installation, a C++ compiler,
and the `caravel_vscpu3x` submodule inside this repository. Initialize it after
cloning:

```bash
git submodule update --init -- caravel_vscpu3x
```

The submodule tracks `questa_fix`, which includes the Questa compatibility
fixes. Normal initialization uses the exact commit recorded by the tester.
Both RTL and gate-level simulations use this checkout:

```text
vscpu3x_auto_tester/
|-- caravel_vscpu3x/
|   `-- pdk/                # created by make gl_setup
`-- verification/
```

Build the DPI UART library once, using the include directory from the simulator
installation:

```bash
cd verification/tb/dpi_uart
g++ -m64 -fPIC -shared -o dpi_uart.so dpi_uart.cpp \
  -I"$QUESTA_HOME/include"
cd ../../..
```

Start the generic RTL simulation from the repository root:

```bash
make sim_rtl
```

The DPI UART prints a pseudo-terminal such as `/dev/pts/5`. Use that path as the
runner's serial device in a second terminal:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  cm_standalone /dev/pts/5 run --modbus-timeout 60
```

Run the simulation from the ModelSim prompt while the Python runner drives the
test through Modbus RTU.

Remove generated ModelSim files with:

```bash
make clean
```

## Gate-level simulation

Prepare the PDK from the repository root, then start the simulation:

```bash
make gl_setup
make sim_gl
```

`gl_setup` initializes the recorded Caravel submodule commit, creates a Python
virtual environment at `.venv/`, and runs Caravel's `make install` if its nested
`caravel/` checkout is absent. It then calls `make pdk-with-volare` from
`caravel_vscpu3x/` with the virtual environment activated and `PDK_ROOT` set to
`caravel_vscpu3x/pdk/`. Caravel's Makefile handles Volare installation and the
pinned PDK revision.

Setup requires Python with `venv` support (the `python3-venv` package on
Debian/Ubuntu) and network access. Re-running `make gl_setup` reuses the nested
Caravel checkout and installed PDK. No manual shell activation is required.
`PYTHON` and `VENV_DIR` can be overridden on the make command line.

Build the DPI UART library as described above before running `sim_gl`.
The gate-level flow uses functional cell models without SDF timing annotation
and the same testbench and Modbus runner as RTL simulation.
