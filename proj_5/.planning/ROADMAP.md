# Roadmap: Project 5 (MPI Programming)

## Milestone 1: Problem 1 - Ping-Pong (30 pts)
- Implement `pingpong_MPI.c` with array bouncing (1000 times).
- Measure communication time for specified array sizes.
- Update `sbatch` files for single vs. multi-node execution.
- Deliver: Source code, Makefile, and Sbatch files.

## Milestone 2: Problem 2 - Parallel Dot Product (20 pts)
- Implement `dot_product_MPI.c` using `MPI_Scatter` and `MPI_Reduce`.
- Compare results with serial implementation.
- Measure performance for 2, 4, 8 processes.
- Deliver: Source code, Makefile, and Sbatch file.

## Milestone 3: Problem 3 - Parallel Merge Sort (30 pts)
- Implement `merge_sort_MPI.c` with `qsort` and tree-based merge reduction.
- Correctly handle MPI ranks for sender/receiver at each iteration.
- Compare same-node vs. different-node performance for 4 processes.
- Deliver: Source code, Makefile, and Sbatch files.

## Milestone 4: Problem 4 - Monte Carlo Pi (20 pts)
- Implement `pi_MPI.c` using Monte Carlo estimation.
- Correctly handle seeds based on process IDs.
- Sum partial counts on Process 0.
- Deliver: Source code, Makefile, and Sbatch file.

## Milestone 5: Report & Submission
- Collect all timing results and generate tables (Wall-clock, Speedup, Efficiency).
- Generate plots for Problem 1 and perform linear regression.
- Discussion on scalability and communication costs for all problems.
- Final PDF Report and ZIP submission.
