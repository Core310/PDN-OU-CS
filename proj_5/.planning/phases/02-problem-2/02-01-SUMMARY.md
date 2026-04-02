---
phase: 02-problem-2
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented a parallel dot product in C using MPI, following the detailed plan in `02-01-PLAN.md`.

### Key Changes
- **`Problem_2/dot_product_MPI.c`**:
    - Added logic to parse command-line arguments.
    - Implemented memory allocation for global vectors on rank 0 and local chunk buffers on all ranks, using the `double` data type.
    - On rank 0, read input vectors from CSV files, including error handling for `fopen`.
    - Used a `MAX_LINE_LEN` of 128 for robust line reading.
    - Implemented the core parallel algorithm:
        - Used `MPI_Scatter` to distribute the global vectors.
        - Calculated the local dot product on each rank.
        - Used `MPI_Reduce` with `MPI_SUM` to aggregate the final result on rank 0.
    - Added timing using `MPI_Wtime()` around the computation phase.
    - On rank 0, wrote the final dot product and elapsed time to the specified output CSV files with `%.6f` precision.

### Verification
- The code was successfully compiled using `mpicc`.
- A basic `mpirun` test with 2 processes completed without errors, confirming the implementation was sound.
- Final verification was delegated to the autograder execution in the next plan (`02-02-PLAN.md`).
