# Phase 2: Problem 2 (Parallel Dot Product) - Context

**Generated:** 2026-03-30
**Phase:** 02-problem-2

## Summary of Decisions

This document outlines the locked-in design and implementation decisions for the Parallel Dot Product phase, as determined through discussion. These decisions are binding for the research and planning stages.

## Locked Decisions

### 1. Data Types
- **Decision:** All floating-point calculations, vector storage, and MPI communication will use the `double` data type.
- **MPI Type:** `MPI_DOUBLE`.
- **Rationale:** Ensures consistency with the serial reference implementation, provides necessary precision, and mitigates risks of floating-point inaccuracies that could cause the exact-match autograder to fail.

### 2. Memory Allocation Strategy
- **Decision:** A standard `MPI_Scatter` memory pattern will be used.
- **Process:**
    1. **Rank 0:** Allocates memory for the two full input vectors.
    2. **All Ranks:** Allocate memory for their local chunks (`n_items / comm_size`).
- **Rationale:** This is the most direct and idiomatic approach for using `MPI_Scatter`, which requires a contiguous data block on the root process.

### 3. Error Handling
- **Decision:** The implementation will include error handling exclusively for file I/O operations.
- **Checks to Implement:**
    - Verify that the input vector CSV files opened successfully (i.e., `fopen` does not return `NULL`).
- **Checks to Omit:**
    - No checks for `malloc` failures.
    - No checks for uneven data distribution (`n_items % comm_size != 0`), as project constraints guarantee this will not occur.
- **Rationale:** Prioritizes handling the most likely and predictable user-level error (missing files) while keeping the code focused on the core MPI logic.

### 4. CSV Parsing
- **Decision:** The buffer size for reading lines from the input CSV files will be increased.
- **Implementation:** The `MAXCHAR` or equivalent preprocessor directive will be set to `128`.
- **Rationale:** This is a simple and effective way to make the file parsing more robust and prevent potential buffer overflows or incorrect reads, which could occur with a small, fixed-size buffer.

## Next Steps
With these decisions locked in, the next action is to proceed with the detailed implementation plan for this phase.
