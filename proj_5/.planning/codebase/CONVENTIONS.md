# Coding Conventions

**Analysis Date:** 2023-10-27

## Naming Patterns

**Files:**
- C Source Files: `problem_name_MPI.c` (e.g., `Problem_1/pingpong_MPI.c`, `Problem_2/dot_product_MPI.c`)
- Sbatch Scripts: `script_name.sbatch` (e.g., `Problem_1/pingpong_diffnode.sbatch`)
- Python Autograders: `autograder_problem_5_X.py` in `tests/Project_5_Tests/Autograder/`
- Shell Scripts: `X_batch.sh` in `tests/Project_5_Tests/Autograder/test_scripts/`

**Functions:**
- Standard C snake_case for user-defined functions.
- `main` entry point for all MPI programs.

**Variables:**
- Standard C snake_case (e.g., `my_rank`, `comm_sz`, `ping_array`).
- MPI-specific variables often include `my_rank` and `comm_sz` (or `comm_size`).

**Types:**
- Standard C types and MPI types (`MPI_Comm`, `MPI_Status`, etc.).

## Code Style

**Formatting:**
- Multi-line block comments for section headers and parallel strategy descriptions.
- Minimalist approach: Zero single-line comments (`//`) allowed.
- Precision: Time measurements must be output using `%.6f` precision.

**Linting:**
- Not explicitly enforced via tool, but strictly audited for mandates.
- Mandates include:
  - No `//` comments.
  - No redundant comments.
  - Multi-line block comments for logical sections.
  - Traceability: Mandatory quotes from `Project_5_Instructions.pdf` with page numbers.

## Import Organization

**Order:**
1. Standard C libraries (`<stdlib.h>`, `<stdio.h>`, etc.)
2. Math/Time libraries (`<math.h>`, `<time.h>`)
3. MPI library (`"mpi.h"`)

**Path Aliases:**
- None detected.

## Error Handling

**Patterns:**
- Strict CLI argument count checking at the beginning of `main`.
- Process 0 is typically responsible for printing error messages.
- Use of `MPI_Abort` or `MPI_Finalize` followed by `return EXIT_FAILURE` on error.
- Checking for file pointer nullity after `fopen`.

## Logging

**Framework:** `printf` (standard stdout) and file-based CSV output.

**Patterns:**
- Process 0 usually handles all console output to avoid interleaved messages.
- Results and execution times are written to CSV files as specified by CLI arguments.

## Comments

**When to Comment:**
- Major logical sections.
- Parallel strategies and data distribution steps.
- Direct quotes from project instructions for traceability.

**JSDoc/TSDoc:**
- Not applicable (C/Python codebase). Python scripts use triple-quote docstrings for classes and methods.

## Function Design

**Size:**
- Kept focused and modular.
- Parallel logic should be clean.

**Parameters:**
- Standard C parameter passing.
- MPI functions use standard MPI parameter patterns (buffers, counts, types, ranks, tags, communicators).

**Return Values:**
- `main` returns `0` on success or `EXIT_FAILURE` on error.

## Module Design

**Exports:**
- C files are generally self-contained programs with a `main` function.
- Shared logic (if any) is recommended to be in a `setup/` module (per `CODING_GUIDELINES.md`).

**Barrel Files:**
- None.

---

*Convention analysis: 2023-10-27*
