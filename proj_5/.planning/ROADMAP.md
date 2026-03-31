# Roadmap: Project 5 (MPI Programming)

## Milestone 1: Problem 1 - Ping-Pong (30 pts)
- Implement `pingpong_MPI.c` with array bouncing (1000 times).
- Measure communication time for specified array sizes.
- Update `sbatch` files for single vs. multi-node execution.
- Deliver: Source code, Makefile, and Sbatch files.

## Milestone 2: Problem 2 - Parallel Dot Product (20 pts)
**Goal:** Parallelize dot product using MPI collective communication (MPI_Scatter, MPI_Reduce).
**Plans:** 2 plans
- [ ] 02-01-PLAN.md — Parallel Dot Product Implementation
- [ ] 02-02-PLAN.md — Autograder Verification

## Milestone 3: Problem 3 - Parallel Merge Sort (30 pts)
**Goal:** Implement `merge_sort_MPI.c` with `qsort` and tree-based merge reduction.
**Plans:** 1 plan
- [ ] 03-01-PLAN.md — Parallel Merge Sort Implementation

## Milestone 4: Problem 4 - Monte Carlo Pi (20 pts)
**Goal:** Implement `pi_MPI.c` using Monte Carlo estimation.
**Plans:** 1 plan
- [ ] 04-01-PLAN.md — Implement Monte Carlo Pi

## Milestone 5: Report & Submission
- Collect all timing results and generate tables (Wall-clock, Speedup, Efficiency).
- Generate plots for Problem 1 and perform linear regression.
- Discussion on scalability and communication costs for all problems.
- Final PDF Report and ZIP submission.
