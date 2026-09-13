# Compact three-core memory chain

`memory_chain` combines a full sweep of unused local RAM on A0, CM and CT,
interactive UART on CM, and generated GPIO input/output patterns on CT.
The tester compares only shared words 0, 1 and 2, plus UART and GPIO buffers.

We use this test for a short load time / high coverage scenario. Compact program
images keep loading time short by leaving the test arrays out of the transfer;
the cores populate and exercise those arrays at runtime. This provides broad
functional coverage of local RAM, shared-memory handoffs, UART, and GPIO in one
test.

The supplied case uses A0 seed `0x1A2B3C4D`, UART input `VSCPU3x` followed by
NUL, and 32 GPIO samples. Its output is exactly `Hello VSCPU3x` (no newline).

| Core | Local capacity (words) | Loaded image (words) | Array word addresses, inclusive | Array words | Shared result |
| --- | ---: | ---: | --- | ---: | --- |
| A0 | 1536 | 132 | 132–1535 | 1404 | `shm[0] = 0x31F19976` |
| CM | 2048 | 258 | 258–2047 | 1790 | `shm[1] = 0x58E8985B` |
| CT | 2560 | 247 | 247–2559 | 2313 | `shm[2] = 0xC94FC999` |

These sizes describe the supplied compiler build. Regeneration measures the
actual image and recomputes the expected results if compiler output changes.
Every address and size above counts **32-bit words**, not bytes. The arrays
cover 5,507 words, or 89.6% of the combined local RAM. The remaining 637 words
hold instructions, constants, and compiler working storage.

## Memory sequence

All three cores use the same unsigned 32-bit polynomial:

```c
f(x) = (1664525 * x + 1013904223) modulo 2^32
```

Each array word is processed in this order:

```c
*cursor = polynomial(state);  /* write the result */
*cursor = ~*cursor;           /* read it, invert it, write it back */
state = ~*cursor;             /* read the stored inverse for the next input */
cursor++;
```

The next iteration consequently writes `f(~array[n])` to `array[n+1]`.
Each cell receives both a value and its bitwise complement and has the exact
transaction order **write, read, write, read**. After the final iteration, the
last valid cell is read once more and its stored, inverted value is published.
The requested `array[len(array)]` is interpreted as `array[len(array)-1]`;
the one-past-end address is never dereferenced.

A0 starts with its generated immediate seed, writes `shm[0]`, then sets bit 0
of `shm[3]`. CM first receives and echoes the NUL-terminated UART name after
`Hello `, waits for bit 0, sweeps its own array seeded by `shm[0]`, writes
`shm[1]`, then sets bit 1. CT first completes the GPIO test, waits for bit 1,
sweeps its array seeded by `shm[1]`, writes `shm[2]`, then sets bit 2.
All cores return. Done flags progress `0 -> 1 -> 3 -> 7`; their updates are
serialized and preserve previously set bits.

The odd polynomial multiplier makes each step a permutation of 32-bit values:
a single changed read value cannot disappear solely through later polynomial
steps. This remains a compact forward memory test, not an exhaustive test of
address aliasing, retention, coupling faults, or every possible instruction
operand. Instruction-model execution exercises all eight opcode families and
12 of the 16 opcode/immediate forms; RTL coverage has not been measured.

## GPIO and UART

CT starts with GPIO state `0x2AA`. For each input sample it computes
`state = f((input & 0x3FF) ^ state) & 0x3FF`, using the same polynomial function
as the memory sweep. GPI/GPO bits 9:0 carry data, and bit 10 carries the
tester handshake. CT acknowledges both edges for each sample and the final
extra rising edge required by the existing driver (N + 1 rising edges for N
samples). The length can be generated from 1 through 127 samples.

CM reads each UART byte before requesting its FIFO pop and waits for the pop
request to clear. It also waits for the TX staging count before every output
byte. The memory sweeps run after the greeting, allowing the UART FIFO to
drain before all cores return. CM's default sweep alone executes at least
87,710 instructions after the last TX staging wait; at the current 50 MHz
simulation clock, even a one-cycle-per-instruction lower bound is 1.75 ms,
longer than 17 outstanding 8N1 bytes at 115200 baud (1.48 ms). The following
CT sweep provides additional time. A future shorter assembly implementation
or a different clock/baud rate should reassess that drain interval.

## Generate and inspect

From the `vscpu3x_auto_tester` directory:

```sh
python3 vscpu3x_apps/tests/memory_chain/generate.py
```

Edit these settings near the top of `generate.py`:

- `A0_SEED`: known 32-bit initial calculation seed.
- `RX_NAME`: ASCII name, with no embedded NUL, up to 250 bytes.
- `PATTERN_LENGTH_MIN` / `PATTERN_LENGTH_MAX`: GPIO sample range; equal values
  select a fixed length.
- `RANDOM_SEED`: reproducible GPIO generation; `None` selects and reports a
  fresh seed.
- `GPIO_INITIAL_SEED`: initial ten-bit GPIO state.
- `COMPILER_PATH` / `ASM_TO_MEM_PATH`: local tool locations.

The readable C sources are under `src/`. The generator writes flattened C,
parameter headers, annotated assembly, and `manifest.json` under
`src/generated/`. Runnable files are written under `generated/`; the shipped
default images are under `pregenerated/`. The manifest records the compiled
layout, instruction counts, seeds, expected values, and compiler binary hash.

The generator compiles each program until `ARRAY_BASE` equals the first word
after the entire emitted image, including compiler working storage. It checks
that the image is contiguous, uses stackless calling, fits local RAM, and leaves
at least one array word. A pointer spans the remaining memory: **no array
initializer or array data words are emitted or loaded**. Each first access to
an array cell is a write, so old or uninitialized tail contents are irrelevant.
All three builds and conversions must succeed before artifacts are published.

The readable C marks RAM and MMIO accesses `volatile`. The current `vscc` does
not parse that qualifier, so the generator removes it in the flattened C only.
The backend retains these accesses; the execution tests verify their actual
instruction-level transaction order. Recheck those tests after compiler changes.

## Checker and validation

`memory_chain_shd.mem` initializes exactly four shared words to zero.
`memory_chain_shd_chk.mem` specifies only addresses 0–2. There are no local
RAM check images, and shared word 3 is used only for synchronization. GPIO
and UART stimulus/expected files use the existing runner's naming convention.
The test is automatically discoverable; it needs no runner registration.

The focused host tests require no RTL simulator or hardware connection:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover \
  -s verification/scripts/tests -p 'test_memory_chain_*.py' -v
```

They execute the final machine words with an independent Python instruction
and MMIO model, poison unloaded tail memory, check every array transaction,
exercise different seeds and GPIO lengths, and verify UART, GPIO, shared
handoffs, and the loader's check masks. FakeModbus verifies runner integration.
These are functional software checks; **Questa has not been run**.

When the simulator or hardware is available, the normal runner command is:

```sh
python3 verification/scripts/vscpu3x_auto_tester.py \
  memory_chain /dev/ttyUSB0 run --generated
```

Omit `--generated` to use the supplied default images. Generation alone does
not launch Questa, open a serial port, or load a device.
