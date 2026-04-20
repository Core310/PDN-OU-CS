# Requirements: Project 5 (MPI Programming)

## Problem 1: Ping-Pong Communication
- **Goal:** Measure communication time between two processes for different array sizes.
- **Sizes:** 1 million, 2 million, 4 million, 8 million integers.
- **Scenarios:**
  - (a) Two different compute nodes.
  - (b) One compute node.
- **Outputs:**
  - `pingpong_MPI n_items time_prob1_MPI.csv`
  - Two plots: x-axis = array size, y-axis = average transmission time (one-way).
  - Estimate latency and bandwidth using linear regression.
- **Grading:** 18 pts (code/makefile), 2 pts (sbatch), 5 pts (plot), 5 pts (linear regression).

## Problem 2: Parallel Dot Product
- **Goal:** Implement parallel dot product using collective communication.
- **Sizes:** 262144, 524288, 1048576.
- **Processors:** 2, 4, 8.
- **Patterns:** Process 0 reads inputs, scatters to others, and reduces results.
- **Usage:** `dot_product_MPI n_items vec_1.csv vec_2.csv result_prob2_MPI.csv time_prob2_MPI.csv`
- **Report:** Wall-clock time, speedup, and efficiency tables. Discussion on scalability.
- **Grading (CS5473):** 9 pts (code/makefile), 1 pt (sbatch), 5 pts (results), 5 pts (table).

## Problem 3: Parallel Merge Sort
- **Goal:** Implement parallel merge sort using tree reduction pattern.
- **Sizes:** 262144, 524288, 1048576.
- **Processors:** 4 (same node vs. different nodes).
- **Steps:**
  1. Process 0 reads global array.
  2. Scatter to all processes.
  3. Local sort using `qsort`.
  4. Tree-based merge to global array on Process 0.
- **Usage:** `merge_sort_MPI n_items input.csv output.csv time_prob3_MPI.csv`
- **Report:** Wall-clock time, speedup, and efficiency tables. Discussion on scalability and communication cost.
- **Grading:** 20 pts (code/makefile), 2 pts (sbatch), 5 pts (results), 3 pts (table).

## Problem 4: Monte Carlo Pi Estimation (Graduate Only)
- **Goal:** Estimate Pi using Monte Carlo method.
- **Points:** $n = 2^{16}$ (fixed total).
- **Processors:** 2, 4, 8, 16.
- **Steps:** Each process generates a subset of random points (different seeds based on process ID) and counts those in the quadrant. Process 0 sums counts and computes Pi.
- **Usage:** `pi_MPI result_prob4_MPI.csv time_prob4_MPI.csv`
- **Report:** Wall-clock time, speedup, and efficiency tables. Discussion on scalability.
- **Grading:** 10 pts (code/makefile), 3 pts (results within 5%), 2 pts (sbatch), 5 pts (table).
