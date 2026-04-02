# Project 5: Parallel MPI Algorithms

## Phase 2: Problem 2 - Parallel Dot Product

### Detailed Implementation Steps:
1.  **CLI Argument Handling:**
    *   Verify `argc == 6`.
    *   Parse `n_items` (array size), `vec_1.csv`, `vec_2.csv`, `result.csv`, and `time.csv`.
2.  **Memory Management:**
    *   Each process determines its local chunk size: `n_local = n_items / comm_sz`.
    *   Rank 0 allocates full vectors for both input vectors.
    *   All processes allocate local buffers for their vector chunks.
3.  **File I/O (Rank 0):**
    *   Read `vec_1.csv` and `vec_2.csv` into the full vector buffers.
4.  **Parallel Distribution:**
    *   `MPI_Scatter` both vectors from Rank 0 to all processes.
5.  **Computation:**
    *   Start timer with `MPI_Wtime()`.
    *   Each process computes the local dot product of its chunks.
    *   `MPI_Reduce` local sums into a global scalar result at Rank 0 using `MPI_SUM`.
    *   Stop timer with `MPI_Wtime()`.
6.  **Output (Rank 0):**
    *   Write the global scalar result to `result.csv` with `%.6f` precision.
    *   Write the execution time to `time.csv` with `%.6f` precision.
7.  **Finalization:**
    *   Deallocate all memory and call `MPI_Finalize()`.
8.  **Verification:**
    *   Compile using the provided `Makefile`.
    *   Run `autograder_problem_5_2.py` to confirm correctness.
