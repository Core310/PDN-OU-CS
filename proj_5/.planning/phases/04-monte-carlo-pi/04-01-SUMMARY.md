---
phase: 04-monte-carlo-pi
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented and verified the parallel Monte Carlo Pi estimation using MPI in `Problem_4/pi_MPI.c`, ensuring it compiles via the Makefile and the Slurm batch script (`pi.sbatch`) is configured correctly. The implementation was verified through successful compilation, execution on the Schooner cluster, and subsequent passing of autograder tests.

### Key Changes
- **`Problem_4/pi_MPI.c`**:
    - Included necessary headers (`mpi.h`, `stdio.h`, `stdlib.h`, `time.h`, `math.h`).
    - Initialized MPI (`MPI_Init`, `MPI_Comm_rank`, `MPI_Comm_size`) and finalized (`MPI_Finalize`).
    - Added command-line argument validation (`argc == 4`).
    - Seeded the random number generator using `srand48(time(NULL) + world_rank)` to ensure different sequences per process.
    - Defined `TOTAL_POINTS` (e.g., 2^16) and calculated `num_iterations_per_process` as `TOTAL_POINTS / comm_size`.
    - Implemented a loop to generate `num_iterations_per_process` random (x, y) points using `drand48()` and counted points falling inside the unit circle (`local_in_circle_count`).
    - Used `MPI_Reduce` to sum `local_in_circle_count` across all processes to `global_in_circle_count` on the root process (rank 0).
    - On the root process, calculated Pi using the formula `pi_estimate = 4.0 * (double)global_in_circle_count / total_points;`.
    - Implemented `MPI_Wtime()` for timing the Monte Carlo simulation part and wrote the `elapsed_time` to the time output file.
    - Wrote the estimated Pi value to the result output file with `%.6f` precision.
- **`Problem_4/Makefile`**:
    - Configured existing `Makefile` to correctly compile `pi_MPI.c` into `pi_MPI` executable using `mpicc`. No modifications were needed.
- **`Problem_4/pi.sbatch`**:
    - Updated `SBATCH --chdir`, `SBATCH --output`, and `SBATCH --error` paths to be user-specific.
    - **Changed `srun` to `mpirun` for launching MPI jobs** due to PMI support issues on Schooner.
    - Adjusted output filenames (e.g., `result_2p.csv` to `result_2p_prob4.csv`) for clarity and to match the problem context.
    - Explicitly set `#SBATCH --ntasks`, `--ntasks-per-node`, and `--nodes` directives to avoid "More processors requested than permitted" errors.

### Verification
- **Compilation & Execution**: Successfully compiled `pi_MPI.c` and executed it via the updated `pi.sbatch` on the Schooner cluster. This generated the required `result_*.csv` and `time_*.csv` files in the `Problem_4/` directory.
- **Autograder**: The main autograder script (`run_autograder.sh`) correctly evaluated the generated data for Problem 4, confirming the accuracy of the Pi estimation (all tests passed). This also involved fixing an autograder pathing issue (`in_test_files`) during verification.

### Outcome
Problem 4 (Monte Carlo Pi Estimation) is fully implemented, configured for the Schooner cluster, and its correctness and performance have been successfully verified by the autograder. The generated data is available for inclusion in the final report.
