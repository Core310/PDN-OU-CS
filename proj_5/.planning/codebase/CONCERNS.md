# Codebase Concerns

**Analysis Date:** 2025-05-15

## Tech Debt

**Problem 1 Implementation:**
- Issue: `pingpong_MPI.c` contains only boilerplate and `TODO` markers. It is currently non-functional.
- Files: `Problem_1/pingpong_MPI.c`
- Impact: Project cannot be tested or verified for Problem 1.
- Fix approach: Complete the MPI message passing logic (blocking send/receive).

**Problem 3 Implementation:**
- Issue: `merge_sort_MPI.c` contains initialization and read/sort helpers but lacks the actual parallel merge sort logic.
- Files: `Problem_3/merge_sort_MPI.c`
- Impact: Project cannot be tested or verified for Problem 3.
- Fix approach: Implement recursive merge sort with MPI partitioning (Scatter/Gather or tree-based).

## Missing Critical Features

**Problem 2 MPI Source:**
- Problem: `dot_product_MPI.c` is completely missing from the `Problem_2/` directory, though the `Makefile` and `sbatch` script reference it.
- Blocks: Compilation and testing of Problem 2's parallel solution.
- Files: `Problem_2/`

**Problem 4 MPI Source:**
- Problem: `pi_MPI.c` is completely missing from the `Problem_4/` directory, though the `Makefile` and `sbatch` script reference it.
- Blocks: Compilation and testing of Problem 4's parallel solution.
- Files: `Problem_4/`

## Fragile Areas

**Problem 1 Argument Validation:**
- Files: `Problem_1/pingpong_MPI.c`
- Why fragile: The `argc` check `if (argc != 10)` contradicts the usage string `"USE LIKE THIS: pingpong_MPI n_items time_prob1_MPI.csv"`. This will cause the program to fail immediately upon execution even if the logic is implemented.
- Safe modification: Update `argc` check to `3` to match the expected two arguments plus the program name.

**Problem 2 Serial Sbatch Script:**
- Files: `Problem_2/serial/prob3_serial.sbatch`
- Why fragile: The script name refers to "prob3" but it is located in "Problem 2". This may lead to confusion during execution and result reporting.
- Safe modification: Rename to `dot_product_serial.sbatch` for consistency.

## Test Coverage Gaps

**Untested Parallel Logic:**
- What's not tested: All parallel logic across Problems 1-4 is either missing or stubbed.
- Files: `Problem_1/pingpong_MPI.c`, `Problem_2/`, `Problem_3/merge_sort_MPI.c`, `Problem_4/`
- Risk: High risk of runtime deadlocks or incorrect calculations once logic is implemented.
- Priority: High

---

*Concerns audit: 2025-05-15*
