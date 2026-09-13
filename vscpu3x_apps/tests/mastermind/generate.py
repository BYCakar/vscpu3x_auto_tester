#!/usr/bin/env python3
"""Generate a randomized three-core VSCPU3x Mastermind testcase.

This script deliberately accepts no command-line arguments. Edit the
configuration values below when a reproducible or locally customized build is
needed.
"""

from __future__ import annotations

import random
import subprocess
import sys
import tempfile
from pathlib import Path


# Editable generator configuration.
TEST_ROOT = Path(__file__).resolve().parent
AUTO_TESTER_ROOT = TEST_ROOT.parents[2]
WORKSPACE_ROOT = TEST_ROOT.parents[3]
COMPILER_PATH = WORKSPACE_ROOT / "compiler" / "vscc"
ASM_TO_MEM_PATH = AUTO_TESTER_ROOT / "verification" / "scripts" / "asmtomem.py"

# None produces and reports a fresh 64-bit seed. Set an integer to reproduce a
# randomized case, or set FIXED_SECRET to four base-8 digits for a specific one.
RANDOM_SEED: int | None = None
FIXED_SECRET: str | None = None

# The hardware UART RX ring holds 256 bytes. Candidate secrets are retried
# until the independently generated transcript fits this configurable limit.
MAX_EXPECTED_UART_BYTES = 256


SOURCE_DIR = TEST_ROOT / "src"
SOURCE_GENERATED_DIR = SOURCE_DIR / "generated"
OUTPUT_DIR = TEST_ROOT / "generated"
SECRET_HEADER = SOURCE_GENERATED_DIR / "mastermind_secret.h"
EXPECTED_UART = OUTPUT_DIR / "mastermind_uart_rx_buf.txt"
SHARED_MEMORY = OUTPUT_DIR / "mastermind_shd.mem"

CORE_SOURCES = {
    "cm": SOURCE_DIR / "codemaker.c",
    "ct": SOURCE_DIR / "control_tower.c",
    "a0": SOURCE_DIR / "agent_1.c",
}
CORE_CAPACITIES = {"cm": 2048, "ct": 2560, "a0": 1536}
FIXED_GUESSES = ("1234", "5670")
MAX_SCORE_PAIRS = 10
UART_RX_CAPACITY_BYTES = 256


class GenerationError(RuntimeError):
    """The configured sources or tools could not produce a safe testcase."""


class IneligibleSecret(GenerationError):
    """A valid secret does not fit the configured firmware/test capacities."""


def validate_secret(secret: str) -> None:
    if len(secret) != 4 or any(digit not in "01234567" for digit in secret):
        raise GenerationError(
            f"secret {secret!r} must contain exactly four base-8 digits"
        )


def score(guess: str, answer: str) -> tuple[int, int]:
    """Mirror the firmware's right-to-left digit matching exactly."""
    guess_used = [False, False, False, False]
    answer_used = [False, False, False, False]
    plus = 0
    minus = 0

    for index in range(3, -1, -1):
        if guess[index] == answer[index]:
            guess_used[index] = True
            answer_used[index] = True
            plus += 1

    for guess_index in range(3, -1, -1):
        if guess_used[guess_index]:
            continue
        for answer_index in range(3, -1, -1):
            if answer_used[answer_index] or guess_index == answer_index:
                continue
            if guess[guess_index] == answer[answer_index]:
                guess_used[guess_index] = True
                answer_used[answer_index] = True
                minus += 1
                break

    return plus, minus


def model_guesses(secret: str) -> tuple[str, ...]:
    """Model the fixed openings and Agent 1's ascending base-8 search."""
    history: list[tuple[str, tuple[int, int]]] = []
    guesses: list[str] = []

    for guess in FIXED_GUESSES:
        result = score(guess, secret)
        guesses.append(guess)
        if result[0] == 4:
            return tuple(guesses)
        history.append((guess, result))

    # Agent 1's BCD_inc increments the least-significant nibble first, which
    # is the same ordering as 0000..7777 written as four-digit octal strings.
    for candidate_value in range(8**4):
        candidate = f"{candidate_value:04o}"
        if not all(
            score(previous_guess, candidate) == previous_result
            for previous_guess, previous_result in history
        ):
            continue

        result = score(candidate, secret)
        guesses.append(candidate)
        if result[0] == 4:
            return tuple(guesses)
        history.append((candidate, result))

    raise GenerationError(f"independent model could not solve secret {secret}")


def expected_uart_bytes(secret: str) -> tuple[bytes, tuple[str, ...]]:
    guesses = model_guesses(secret)
    if len(guesses) > MAX_SCORE_PAIRS:
        raise IneligibleSecret(
            f"secret {secret} needs {len(guesses)} score pairs; firmware holds "
            f"only {MAX_SCORE_PAIRS}"
        )

    chunks = [f"sc:{secret}\r\n"]
    for guess in guesses:
        plus, minus = score(guess, secret)
        chunks.append(f"+{plus} -{minus} {guess}\r\n")
    chunks.append("found\r\n")
    return "".join(chunks).encode("ascii"), guesses


def choose_case() -> tuple[str, int | None, bytes, tuple[str, ...]]:
    if not 1 <= MAX_EXPECTED_UART_BYTES <= UART_RX_CAPACITY_BYTES:
        raise GenerationError(
            "MAX_EXPECTED_UART_BYTES must be between 1 and "
            f"{UART_RX_CAPACITY_BYTES}"
        )

    if FIXED_SECRET is not None:
        validate_secret(FIXED_SECRET)
        expected, guesses = expected_uart_bytes(FIXED_SECRET)
        if len(expected) > MAX_EXPECTED_UART_BYTES:
            raise GenerationError(
                f"fixed secret {FIXED_SECRET} produces {len(expected)} UART bytes, "
                f"above the configured limit {MAX_EXPECTED_UART_BYTES}"
            )
        return FIXED_SECRET, RANDOM_SEED, expected, guesses

    effective_seed = RANDOM_SEED
    if effective_seed is None:
        effective_seed = random.SystemRandom().getrandbits(64)
    generator = random.Random(effective_seed)
    candidates = [f"{value:04o}" for value in range(8**4)]
    generator.shuffle(candidates)

    for secret in candidates:
        try:
            expected, guesses = expected_uart_bytes(secret)
        except IneligibleSecret:
            # A randomized candidate that exceeds a firmware/model capacity is
            # ineligible; keep looking instead of aborting the whole run.
            continue
        if len(expected) <= MAX_EXPECTED_UART_BYTES:
            return secret, effective_seed, expected, guesses

    raise GenerationError(
        "no allowed secret produces a transcript within "
        f"MAX_EXPECTED_UART_BYTES={MAX_EXPECTED_UART_BYTES}"
    )


def write_secret_header(
    path: Path,
    secret: str,
    seed: int | None,
    expected_size: int,
    guesses: tuple[str, ...],
) -> None:
    seed_text = "fixed-secret mode" if seed is None else str(seed)
    path.write_text(
        "/* Generated by ../../generate.py; do not edit by hand. */\n"
        f"/* seed: {seed_text}; guesses: {', '.join(guesses)}; "
        f"UART bytes: {expected_size} */\n"
        "#ifndef MASTERMIND_SECRET_H\n"
        "#define MASTERMIND_SECRET_H\n"
        f"#define MASTERMIND_SECRET_BCD 0x{secret}\n"
        f"#define MASTERMIND_SECRET_BCD_PLUS_ONE 0x{int(secret, 16) + 1:04X}\n"
        "#endif\n",
        encoding="ascii",
    )


def compile_core(
    core: str,
    source_path: Path,
    secret_header: Path | None = None,
    assembly_dir: Path | None = None,
) -> Path:
    # Optional destinations keep these helpers convenient to exercise in
    # isolation while main() supplies staging paths for atomic publication.
    if secret_header is None:
        secret_header = SECRET_HEADER
    if assembly_dir is None:
        assembly_dir = SOURCE_GENERATED_DIR

    source = source_path.read_text(encoding="utf-8")
    if core == "cm":
        # vscc consumes C on stdin and intentionally ignores #include lines.
        # Prefix the generated header while retaining the normal include in
        # codemaker.c, so the source remains valid for an include-aware tool.
        compiler_input = secret_header.read_text(encoding="ascii") + "\n" + source
    else:
        compiler_input = source

    result = subprocess.run(
        [str(COMPILER_PATH)],
        cwd=SOURCE_DIR,
        input=compiler_input,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise GenerationError(
            f"compiler failed for {source_path.name} with status "
            f"{result.returncode}:\n{result.stderr.strip()}"
        )
    if not result.stdout.strip():
        raise GenerationError(f"compiler produced empty assembly for {source_path.name}")

    assembly_path = assembly_dir / f"mastermind_{core}.asm"
    assembly_path.write_text(result.stdout, encoding="ascii")
    return assembly_path


def convert_assembly(assembly_path: Path, output_dir: Path | None = None) -> Path:
    if output_dir is None:
        output_dir = OUTPUT_DIR

    result = subprocess.run(
        [sys.executable, str(ASM_TO_MEM_PATH), str(assembly_path)],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise GenerationError(
            f"asmtomem failed for {assembly_path.name} with status "
            f"{result.returncode}:\n{result.stderr.strip()}"
        )
    if "Skipping " in result.stdout:
        raise GenerationError(
            f"asmtomem skipped compiler output for {assembly_path.name}:\n"
            f"{result.stdout.strip()}"
        )

    intermediate_path = assembly_path.with_suffix(".mem")
    if not intermediate_path.is_file():
        raise GenerationError(f"asmtomem did not create {intermediate_path}")
    memory_path = output_dir / intermediate_path.name
    intermediate_path.replace(memory_path)
    return memory_path


def write_shared_memory(path: Path | None = None) -> None:
    if path is None:
        path = SHARED_MEMORY

    # The protocol uses the guess/score table at 0..9, handshake words at
    # 10..12 and 20, and the Agent candidate at 25. Clear the whole span so a
    # previous testcase cannot satisfy a wait condition with stale data.
    path.write_text(
        "@0\n" + "00000000\n" * 26,
        encoding="ascii",
    )


def validate_memory_image(path: Path, capacity: int) -> int:
    words: dict[int, int] = {}
    address = 0

    for line_number, raw_line in enumerate(path.read_text(encoding="ascii").splitlines(), 1):
        line = raw_line.split("//", 1)[0].split("#", 1)[0]
        for token in line.split():
            if token.startswith("@"):
                try:
                    address = int(token[1:].replace("_", ""), 16)
                except ValueError as exc:
                    raise GenerationError(
                        f"{path}:{line_number}: invalid address {token!r}"
                    ) from exc
                continue
            try:
                value = int(token.replace("_", ""), 16)
            except ValueError as exc:
                raise GenerationError(
                    f"{path}:{line_number}: invalid word {token!r}"
                ) from exc
            if address in words:
                raise GenerationError(
                    f"{path}:{line_number}: duplicate word address {address}"
                )
            if not 0 <= address < capacity:
                raise GenerationError(
                    f"{path}:{line_number}: address {address} exceeds "
                    f"{capacity}-word core capacity"
                )
            if not 0 <= value <= 0xFFFFFFFF:
                raise GenerationError(f"{path}:{line_number}: word exceeds 32 bits")
            words[address] = value
            address += 1

    if not words or 0 not in words:
        raise GenerationError(f"{path}: program is empty or has no word at address 0")
    return len(words)


def validate_tools_and_sources() -> None:
    if not COMPILER_PATH.is_file():
        raise GenerationError(f"compiler does not exist: {COMPILER_PATH}")
    if not ASM_TO_MEM_PATH.is_file():
        raise GenerationError(f"asmtomem script does not exist: {ASM_TO_MEM_PATH}")
    for source_path in CORE_SOURCES.values():
        if not source_path.is_file():
            raise GenerationError(f"source file does not exist: {source_path}")


def main() -> int:
    try:
        validate_tools_and_sources()
        SOURCE_GENERATED_DIR.mkdir(parents=True, exist_ok=True)
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

        secret, seed, expected, guesses = choose_case()
        with tempfile.TemporaryDirectory(
            prefix=".mastermind-generate-", dir=TEST_ROOT
        ) as temporary_directory:
            staging_root = Path(temporary_directory)
            staging_source = staging_root / "src-generated"
            staging_output = staging_root / "generated"
            staging_source.mkdir()
            staging_output.mkdir()

            staging_header = staging_source / SECRET_HEADER.name
            staging_expected = staging_output / EXPECTED_UART.name
            staging_shared = staging_output / SHARED_MEMORY.name
            write_secret_header(
                staging_header, secret, seed, len(expected), guesses
            )
            staging_expected.write_bytes(expected)
            write_shared_memory(staging_shared)

            word_counts: dict[str, int] = {}
            staged_programs: dict[str, tuple[Path, Path]] = {}
            for core, source_path in CORE_SOURCES.items():
                assembly_path = compile_core(
                    core, source_path, staging_header, staging_source
                )
                memory_path = convert_assembly(assembly_path, staging_output)
                word_counts[core] = validate_memory_image(
                    memory_path, CORE_CAPACITIES[core]
                )
                staged_programs[core] = (assembly_path, memory_path)
            word_counts["shd"] = validate_memory_image(staging_shared, 64)

            # Publish only after every compiler/converter/parser check passes,
            # so a failed generation leaves the previous coherent set intact.
            staging_header.replace(SECRET_HEADER)
            staging_expected.replace(EXPECTED_UART)
            staging_shared.replace(SHARED_MEMORY)
            for core, (assembly_path, memory_path) in staged_programs.items():
                assembly_path.replace(
                    SOURCE_GENERATED_DIR / f"mastermind_{core}.asm"
                )
                memory_path.replace(OUTPUT_DIR / f"mastermind_{core}.mem")

        seed_text = "fixed" if seed is None else str(seed)
        print(
            f"Generated mastermind secret={secret} seed={seed_text} "
            f"guesses={len(guesses)} UART-bytes={len(expected)}"
        )
        print(
            "Program words: "
            + ", ".join(
                f"{core}={word_counts[core]}" for core in ("cm", "ct", "a0", "shd")
            )
        )
        return 0
    except (GenerationError, OSError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
