# VSCPU3x Auto Tester

The `dev` branch contains an FPGA-based test controller and a Python runner for
loading and checking VSCPU3x applications over Modbus RTU. Tests can provide
program images, expected memory contents, GPIO samples, and UART data. The
runner records a log and a machine-readable result for every run.

## Repository layout

- `design/src/` - synthesizable auto-tester and Modbus RTL
- `vscpu3x_apps/src/` - file-driven test applications
- `verification/scripts/` - Python command-line runner
- `verification/tb/` - RTL testbench and PTY-backed DPI UART
- `verification/sim/` - Questa/ModelSim compile and waveform scripts

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
`vscpu3x_apps/src/`, pass its directory name, serial device, and mode:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py \
  cm_standalone /dev/ttyUSB0 run
```

Use `all` to run every application in lexical order while keeping one Modbus
connection open:

```bash
python3 verification/scripts/vscpu3x_auto_tester.py all /dev/ttyUSB0 run
```

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

## Test application format

Each immediate directory under `vscpu3x_apps/src/` is a test. File names must
begin with the directory name. For a test named `example`, the runner recognizes:

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

## RTL simulation

RTL simulation requires a 64-bit Questa/ModelSim installation, a C++ compiler,
and the `caravel_vscpu3x` repository next to this repository:

```text
workspace/
|-- caravel_vscpu3x/
`-- vscpu3x_auto_tester/
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
