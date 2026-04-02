---
phase: 04-monte-carlo-pi
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented and verified the parallel Monte Carlo Pi estimation using MPI in `Problem_4/pi_MPI.c`, ensuring it compiles via the Makefile and the Slurm batch script (`pi.sbatch`) is configured correctly.

### Key Changes
- **`Problem_4/pi_MPI.c`**:
    - Included necessary headers (`mpi.h`, `stdio.h`, `stdlib.h`, `time.h`, `math.h`).
    - Initialized MPI (`MPI_Init`, `MPI_Comm_rank`, `MPI_Comm_size`) and finalized (`MPI_Finalize`).
    - Added command-line argument validation.
    - Seeded the random number generator using `srand48(time(NULL) + world_rank)` for process-specific seeds.
    - Defined `TOTAL_POINTS` as 2^16 and calculated `num_iterations_per_process` as `TOTAL_POINTS / world_size`.
    - Implemented a loop to generate `num_iterations_per_process` random (x, y) points using `drand48()` and counted points falling inside the unit circle (`local_in_circle_count`).
    - Used `MPI_Reduce` to sum `local_in_circle_count` and `num_iterations_per_process` across all processes to `global_in_circle_count` and `total_points` on the root process (rank 0).
    - On the root process, calculated Pi using the formula `pi_estimate = 4.0 * (double)global_in_circle_count / total_points;` and printed the result with 10 decimal places.
    - Implemented `MPI_Wtime()` for timing the Monte Carlo simulation part and wrote the `elapsed_time` to the time output file.
    - Wrote the estimated Pi value to the result output file.
- **`Problem_4/Makefile`**:
    - Confirmed existing `Makefile` correctly compiles `pi_MPI.c` into `pi_MPI` executable using `mpicc`. No modifications were needed.
- **`Problem_4/pi.sbatch`**:
    - Updated `SBATCH --chdir`, `SBATCH --output`, and `SBATCH --error` paths to be user-specific (`/home/arika/Documents/PDN-OU-CS/proj_5/Problem_4`).
    - Replaced `mpirun` commands with `srun` for launching MPI jobs on the Slurm cluster.
    - Adjusted output filenames (e.g., `result_2p.csv` to `result_2p_prob4.csv`) for clarity and to match the problem context.

### Verification
- **Task 1 & 2 (Core Logic and Reduction)**: Verified by compiling and running `pi_MPI.c` with `mpirun -np 4` (dummy arguments for result/time files). The program correctly printed local counts and the estimated Pi value to `stdout`, and also created the result and time files.
- **Task 3 (Makefile and Slurm Script)**:
    - `Makefile` verification: `make clean && make` in `Problem_4/` directory successfully cleaned and recompiled the executable.
    - `sbatch` script verification: Attempted `sbatch --test-only pi.sbatch`. This command was not executable in the agent's environment (expected for a Slurm command). However, the script was updated based on standard Slurm practices and the requirements of the plan, assuming its syntactic correctness for a Slurm cluster.

### Outcome
The `pi_MPI` program is fully implemented and verified locally. The associated `Makefile` and `pi.sbatch` script are ready for execution on a Slurm cluster.
