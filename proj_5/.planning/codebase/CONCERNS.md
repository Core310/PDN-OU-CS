# Codebase Concerns

**Analysis Date:** 2024-11-05

## Tech Debt

**Unimplemented Parallel Logic:**
- Issue: Three out of four MPI problems are currently stubs with `TODO` markers. Only Problem 1 is implemented.
- Files: `Problem_2/dot_product_MPI.c`, `Problem_3/merge_sort_MPI.c`, `Problem_4/pi_MPI.c`
- Impact: Core project functionality is missing. Jobs submitted via `.sbatch` will compile but perform no operations.
- Fix approach: Implement the parallel strategies using MPI collective operations as specified in `Project_5_Instructions.pdf`.

**Coding Guideline Violations:**
- Issue: `Problem_3/merge_sort_MPI.c` contains forbidden single-line comments (`//`), violating `CODING_GUIDELINES.md`.
- Files: `Problem_3/merge_sort_MPI.c`
- Impact: Potential grade deduction for non-compliance with project-wide standards.
- Fix approach: Replace all `//` comments with multi-line `/* ... */` comments or remove redundant comments as per guidelines.

**Inconsistent Data Types:**
- Issue: Inconsistent use of `float` and `double` for similar operations (e.g., Problem 2 serial uses `double`, Problem 3 uses `float`).
- Files: `Problem_2/serial/dotprod_serial.c`, `Problem_3/merge_sort_MPI.c`
- Impact: Potential loss of precision or unexpected behavior when comparing results.
- Fix approach: Standardize on `double` for scientific calculations (dot product, pi estimation) and consistent types for sorting.

## Environment Dependencies (Schooner/HPC)

**Hardcoded User Paths:**
- Issue: `.sbatch` files contain hardcoded absolute paths to a specific user's home directory (`/home/oucspdn089/...`).
- Files: `Problem_1/pingpong_diffnode.sbatch`, `Problem_1/pingpong_samenode.sbatch`, `Problem_2/dot_product.sbatch`, `Problem_3/merge_sort_diffnode.sbatch`, `Problem_3/merge_sort_samenode.sbatch`, `Problem_4/pi.sbatch`
- Impact: Job submissions will fail for any other user on the Schooner cluster because the directory structure will not match.
- Fix approach: Use relative paths (e.g., `./` or `../`) or environment variables like `$SLURM_SUBMIT_DIR` to ensure portability.

**Module Load Specificity:**
- Issue: Reliance on specific module versions (`intel/2022.2`, `OpenMPI/4.1.4-GCC-11.3.0`).
- Files: All `.sbatch` files.
- Impact: If the Schooner cluster environment is updated or these modules are removed, the scripts will break.
- Current mitigation: None.
- Recommendations: Check for general module names or ensure environment documentation is up to date.

## MPI Collective Logic

**Implicit Single-Rank I/O:**
- Issue: The current structure (e.g., in Problem 3) assumes Rank 0 reads the entire file and others wait, but some stubs lack proper `my_rank == 0` guards for file opening/reading.
- Files: `Problem_3/merge_sort_MPI.c`
- Risk: If all ranks attempt to read the same file simultaneously, it could lead to I/O contention or wasted memory across nodes.
- Fix approach: Ensure only Rank 0 performs I/O, then use `MPI_Scatter` or `MPI_Bcast` to distribute data.

**Missing Collective Implementations:**
- Issue: Problems 2 and 3 require specific collective logic (`MPI_Scatter`, `MPI_Gather`, `MPI_Reduce`) that is currently missing.
- Files: `Problem_2/dot_product_MPI.c`, `Problem_3/merge_sort_MPI.c`
- Risk: Incorrect partitioning of data can lead to wrong results or deadlocks.

## CSV I/O Constraints

**Fixed Buffer Sizes (MAXLINE):**
- Issue: `MAXLINE` is set to 25 characters, which is extremely tight for scientific floats/doubles if they have many decimal places or use scientific notation.
- Files: `Problem_3/merge_sort_MPI.c`, `Problem_2/serial/dotprod_serial.c`
- Impact: `fgets` might truncate lines, causing `sscanf` to read incorrect values.
- Fix approach: Increase `MAXLINE` (e.g., to 64 or 128) to safely accommodate full-precision floating-point strings.

**Filename Mismatches in SBATCH:**
- Issue: The `.sbatch` scripts reference filenames that do not match the actual files in `tests/Project_5_Tests/test_data/`.
- Files: `Problem_2/dot_product.sbatch` (references `vec_2_18_1.csv`), `Problem_3/merge_sort_samenode.sbatch` (references `../test_data/Problem_3/vec_3_18.csv`)
- Impact: Job execution will fail with "File not found" errors.
- Fix approach: Update `.sbatch` scripts to use the correct paths and filenames (e.g., `../tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv`).

**Performance of sscanf:**
- Issue: Using `sscanf` inside a loop for millions of lines is slow.
- Files: `Problem_3/merge_sort_MPI.c`, `Problem_2/serial/dotprod_serial.c`
- Impact: I/O becomes a significant bottleneck, potentially exceeding the allocated SLURM time limit for large datasets.
- Fix approach: Consider `strtof` or `strtod` for faster parsing.

## Fragile Areas

**SBATCH Job Configuration:**
- Files: All `.sbatch` files.
- Why fragile: They combine absolute paths, specific node counts, and exact filenames. Any change in the environment or project structure requires updates to multiple files.
- Safe modification: Use a central configuration or relative paths for all file references.

## Test Coverage Gaps

**Unit Testing:**
- What's not tested: Individual helper functions (like `read_input` or `cmpfloat`) are not unit-tested.
- Files: `Problem_3/merge_sort_MPI.c`
- Risk: Bugs in basic I/O or comparison logic can be hard to find in a distributed MPI environment.
- Priority: Medium.

---

*Concerns audit: 2024-11-05*
