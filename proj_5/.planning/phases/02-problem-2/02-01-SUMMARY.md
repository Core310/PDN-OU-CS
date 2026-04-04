---
phase: 02-problem-2
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented a parallel dot product in C using MPI, following the detailed plan in `02-01-PLAN.md`. This implementation has been thoroughly verified through compilation, execution on the Schooner cluster, and passing all associated autograder tests.

### Key Changes
- **`Problem_2/dot_product_MPI.c`**:
    - Added logic to parse command-line arguments, including vector size (`n_items`) and input/output file paths.
    - Implemented robust memory allocation for global vectors (on rank 0) and local chunk buffers (on all ranks), explicitly using the `double` data type for calculations.
    - On rank 0, implemented file I/O to read input vectors from CSV files, incorporating essential `fopen` error handling.
    - Utilized a `MAX_LINE_LEN` of 128 for reliable line reading during CSV parsing.
    - Implemented the core parallel algorithm:
        - Used `MPI_Scatter` to efficiently distribute both input vectors from rank 0 to all participating processes.
        - Calculated the local dot product within each process's allocated data chunk.
        - Employed `MPI_Reduce` with `MPI_SUM` to aggregate all local dot products into a single global result on rank 0.
    - Integrated precise timing using `MPI_Wtime()` around the core computation phase.
    - On rank 0, wrote the final global dot product and the measured elapsed time to the specified output CSV files, ensuring `%.6f` precision.
    - Ensured proper memory deallocation and file closure with `fclose` and `MPI_Finalize()`.

### Verification
- **Compilation & Execution**: The code was successfully compiled using `mpicc` and executed via `dot_product.sbatch` on the Schooner cluster, generating the required `result_*.csv` and `time_*.csv` files in the `Problem_2/` directory.
- **Autograder**: The main autograder script (`run_autograder.sh`) correctly evaluated the generated data for Problem 2, confirming the accuracy and performance of the parallel dot product implementation (all tests passed).

### Outcome
Problem 2 (Parallel Dot Product) is fully implemented, configured for the Schooner cluster, and its correctness and performance have been successfully verified by the autograder. The generated data is ready for detailed analysis in the final report.
