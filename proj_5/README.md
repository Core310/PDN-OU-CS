# Project 5: Parallel MPI Algorithms

This project implements and analyzes parallel MPI algorithms for several classic computational problems: Ping-Pong Communication, Dot Product, Merge Sort, and Monte Carlo Pi Estimation. The implementations are designed for execution on a Slurm cluster (specifically Schooner) using OpenMPI. Performance analysis, verification against autograders, and report generation are also integral parts of the project.

## Phase 1: Problem 1 - Ping-Pong Communication

### Description:
This problem involves measuring the latency and bandwidth of MPI point-to-point communication by "ping-ponging" messages of varying sizes between two MPI processes. This is crucial for understanding fundamental communication costs in a distributed memory environment.

### Detailed Implementation Steps:
1.  **MPI Initialization:** Initialize the MPI environment and determine `my_rank` and `comm_size`.
2.  **Argument Handling:** Parse message size (`n_items`) from command-line arguments.
3.  **Data Allocation:** Allocate `float` arrays for sending and receiving messages.
4.  **Ping-Pong Logic:**
    *   For `my_rank == 0` (sender): Initialize the send buffer, send to `my_rank == 1`, receive from `my_rank == 1`.
    *   For `my_rank == 1` (receiver): Receive from `my_rank == 0`, send back to `my_rank == 0`.
    *   Repeat this for a fixed number of rounds to get average timings.
5.  **Timing:** Use `MPI_Wtime()` to measure the elapsed time for the ping-pong communication.
6.  **Output:** Print or write the measured communication time.

## Phase 2: Problem 2 - Parallel Dot Product

### Description:
This problem computes the dot product of two large vectors in parallel using MPI. The vectors are distributed among processes, and each process computes a partial dot product, which is then reduced to a global sum.

### Detailed Implementation Steps:
1.  **CLI Argument Handling:**
    *   Verify `argc == 6` (program name, `n_items`, `vec_1.csv`, `vec_2.csv`, `result.csv`, `time.csv`).
    *   Parse `n_items` (vector size) and file paths.
2.  **MPI Initialization & Error Handling:**
    *   Initialize MPI.
    *   Add `NULL` checks for `fopen` to handle file opening failures.
3.  **Memory Management:**
    *   Each process determines its local chunk size: `local_n = n_items / comm_size`.
    *   Rank 0 allocates full vectors for both input vectors (`vec_a`, `vec_b`).
    *   All processes allocate local buffers (`local_vec_a`, `local_vec_b`) for their vector chunks.
4.  **File I/O (Rank 0):**
    *   Read `vec_1.csv` and `vec_2.csv` into the full vector buffers (`vec_a`, `vec_b`).
    *   Use `double` for all floating-point calculations to maintain precision.
    *   Ensure CSV parsing can handle lines up to `MAX_LINE_LEN` (e.g., 128 characters).
5.  **Parallel Distribution:**
    *   `MPI_Scatter` both `vec_a` and `vec_b` from Rank 0 to all processes' local buffers.
6.  **Computation:**
    *   Start timer with `MPI_Wtime()`.
    *   Each process computes the local dot product of its `local_vec_a` and `local_vec_b` chunks.
    *   `MPI_Reduce` local sums into a global scalar result (`dot_product`) at Rank 0 using `MPI_SUM`.
    *   Stop timer with `MPI_Wtime()`.
7.  **Output (Rank 0):**
    *   Write the global scalar `dot_product` to `result.csv` with `%.6f` precision.
    *   Write the execution time to `time.csv` with `%.6f` precision.
8.  **Finalization:**
    *   Deallocate all memory, `fclose` opened files, and call `MPI_Finalize()`.

## Phase 3: Problem 3 - Parallel Merge Sort

### Description:
This problem implements a parallel merge sort algorithm using MPI to sort a single large array of floating-point numbers. The array is distributed, locally sorted, and then merged back using a tree-based approach.

### Detailed Implementation Steps:
1.  **CLI Argument Handling:**
    *   Verify `argc == 5` (program name, `n_items`, `input.csv`, `output.csv`, `time.csv`).
    *   Parse `n_items` and file paths.
2.  **MPI Initialization & Error Handling:**
    *   Initialize MPI.
    *   Add `NULL` checks for `fopen` to handle file opening failures.
3.  **Memory Management:**
    *   Each process determines its local chunk size: `local_n = n_items / comm_size`.
    *   Rank 0 allocates the full input array (`arr`).
    *   All processes allocate local buffers (`local_arr`) for their array chunks.
4.  **File I/O (Rank 0):**
    *   Read `input.csv` into the full array `arr` on Rank 0 using `read_input()`.
5.  **Parallel Distribution:**
    *   `MPI_Scatter` the `arr` from Rank 0 to all processes' `local_arr` buffers.
6.  **Local Sort:**
    *   Each process sorts its `local_arr` chunk using `qsort()` with a custom `cmpfloat` function.
7.  **Tree-based Merge:**
    *   Implement a logarithmic-time (tree-based) merge pattern. Processes communicate and merge sorted subarrays with their partners until Rank 0 holds the fully sorted array.
    *   This involves `MPI_Probe`, `MPI_Recv`, `MPI_Send`, and merging two sorted arrays into a larger one.
8.  **Timing:** Use `MPI_Wtime()` to measure the elapsed time for the sorting process, reduced to Rank 0 using `MPI_MAX`.
9.  **Output (Rank 0):**
    *   Write the fully sorted array (`local_arr`) to `output.csv` with `%.6f` precision.
    *   Write the execution time to `time.csv` with `%.6f` precision.
10. **Finalization:**
    *   Deallocate all memory, `fclose` opened files, and call `MPI_Finalize()`.

## Phase 4: Problem 4 - Monte Carlo Pi Estimation

### Description:
This problem estimates the value of Pi using the Monte Carlo method in parallel with MPI. Each process generates a portion of random points, determines how many fall within a unit circle, and then uses `MPI_Reduce` to sum up the total hits for a global Pi estimation.

### Detailed Implementation Steps:
1.  **CLI Argument Handling:**
    *   Verify `argc == 4` (program name, `result.csv`, `time.csv`, `total_points`).
    *   Parse `total_points` for the simulation.
2.  **MPI Initialization:** Initialize MPI.
3.  **Random Number Generation Setup:**
    *   Seed the random number generator (`srand48`) using `time(NULL) + my_rank` to ensure different sequences per process.
    *   Define the number of iterations per process: `num_iterations_per_process = total_points / comm_size`.
4.  **Point Generation and Counting:**
    *   Each process generates `num_iterations_per_process` random points `(x, y)` between -1 and 1 using `drand48`.
    *   For each point, check if `x*x + y*y <= 1.0` (inside the unit circle).
    *   Maintain a `local_circle_count`.
5.  **Global Reduction:**
    *   `MPI_Reduce` all `local_circle_count` values to Rank 0 using `MPI_SUM` to get a `global_circle_count`.
6.  **Pi Estimation (Rank 0):**
    *   Calculate Pi: `estimated_pi = 4.0 * global_circle_count / total_points`.
7.  **Timing:** Use `MPI_Wtime()` to measure the elapsed time for the computation, reduced to Rank 0 using `MPI_MAX`.
8.  **Output (Rank 0):**
    *   Write the `estimated_pi` to `result.csv` with `%.6f` precision.
    *   Write the execution time to `time.csv` with `%.6f` precision.
9.  **Finalization:**
    *   `fclose` opened files and call `MPI_Finalize()`.

---

## Running the Project

### 1. Generate Raw Data (on Schooner cluster):
To compile all programs and run all `sbatch` jobs to generate the raw timing and result CSVs, use the provided shell script:
```bash
./run_all_sbatch.sh
```
This script will submit jobs to the Slurm scheduler, and output will be directed to files in the `out/` directory and problem-specific CSVs in `Problem_X/` directories.

### 2. Run the Autograder (on Schooner login node or local machine with `venv`):
After the `sbatch` jobs have completed and produced all output files, run the Python autograder to verify correctness and generate summary tables and plots:
```bash
./run_autograder.sh
```
This script activates the Python virtual environment, loads necessary modules, and then executes the main autograder script (`tests/Project_5_Tests/Autograder/autograder_project_5.py`). It will print the test results to the console, indicating "X/Y problems correct".

## Report Generation:
The autograder output also generates `P5_X_grades.csv` and `P5_X_times.csv` files, which are used by analysis scripts in the `reports/` directory to construct the final `reports/REPORT.md`.
