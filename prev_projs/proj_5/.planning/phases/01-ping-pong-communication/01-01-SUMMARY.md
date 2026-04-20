---
phase: 01-ping-pong-communication
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented and verified the Ping-Pong communication problem for MPI, measuring communication times for array bouncing on both single and multi-node configurations. The implementation was verified through successful compilation, execution on the Schooner cluster, and subsequent passing of autograder tests.

### Key Changes
- **`Problem_1/pingpong_MPI.c`**:
    - The existing `pingpong_MPI.c` file was found to contain a complete and correct implementation of the Ping-Pong communication logic, including MPI initialization, argument parsing, array bouncing between rank 0 and 1 for 1000 iterations, time measurement using `MPI_Wtime`, and output to a specified CSV file. No modifications were needed for the core logic.
- **`Problem_1/Makefile`**:
    - The existing `Makefile` was found to be correctly configured for compiling `pingpong_MPI.c` into the `pingpong_MPI` executable using `mpicc`. No modifications were needed.
- **`Problem_1/pingpong_samenode.sbatch`**:
    - Updated `SBATCH --chdir`, `SBATCH --output`, and `SBATCH --error` paths to be user-specific (`/home/arika/Documents/PDN-OU-CS/proj_5/Problem_1`).
    - Replaced `srun` with `mpirun` for launching MPI jobs due to PMI support issues on Schooner.
    - Explicitly set `#SBATCH --ntasks`, `--ntasks-per-node`, and `--nodes` directives to avoid "More processors requested than permitted" errors.
- **`Problem_1/pingpong_diffnode.sbatch`**:
    - Updated `SBATCH --chdir`, `SBATCH --output`, and `SBATCH --error` paths to be user-specific (`/home/arika/Documents/PDN-OU-CS/proj_5/Problem_1`).
    - Replaced `srun` with `mpirun` for launching MPI jobs due to PMI support issues on Schooner.
    - Explicitly set `#SBATCH --ntasks`, `--ntasks-per-node`, and `--nodes` directives.

### Verification
- **Compilation & Execution**: Successfully compiled `pingpong_MPI.c` and executed it via updated `sbatch` scripts (`pingpong_samenode.sbatch`, `pingpong_diffnode.sbatch`) on the Schooner cluster. This generated the required `time_*.csv` files in the `Problem_1/` directory.
- **Autograder**: The main autograder script (`run_autograder.sh`) correctly evaluated the generated data, confirming the successful execution and data generation for Problem 1.

### Outcome
Problem 1 (Ping-Pong Communication) is fully implemented, configured for the Schooner cluster, and its execution has been successfully verified by the autograder. The timing data is available for inclusion in the final report.
