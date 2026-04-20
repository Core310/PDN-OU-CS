---
phase: 03-problem-3
plan: 01
summary: true
---

## Summary of Work (Plan 01)

### Objective
Implemented a parallel merge sort algorithm in C using MPI (`merge_sort_MPI.c`) and thoroughly verified its correctness and performance through compilation, execution on the Schooner cluster, and successful passing of all associated autograder tests.

### Key Changes
- **`Problem_3/merge_sort_MPI.c`**:
    - Implemented command-line argument parsing for array size (`n_items`) and input/output file paths.
    - Integrated essential MPI initialization (`MPI_Init`, `MPI_Comm_rank`, `MPI_Comm_size`).
    - Added critical `fopen` NULL checks to prevent segmentation faults due to inaccessible input files.
    - Allocated memory for a global array on Rank 0 and local chunks (`local_arr`) on all processes.
    - Implemented a `read_input` function to parse input `float` values from a CSV file.
    - Utilized `MPI_Scatter` to distribute the initial unsorted array from Rank 0 to all processes.
    - Each process performed a local sort on its `local_arr` chunk using `qsort()` with a custom `cmpfloat` comparison function.
    - Implemented a tree-based merge strategy where processes communicate and merge their sorted subarrays iteratively until Rank 0 holds the fully sorted result.
    - Measured computational time using `MPI_Wtime()` and reduced to Rank 0 using `MPI_MAX`.
    - On Rank 0, wrote the final sorted array to `output.csv` and the execution time to `time.csv` with `%.6f` precision.
    - Ensured proper memory deallocation and file closure (`fclose`, `MPI_Finalize`).
    - **Critical Fixes during debugging**:
        - Corrected a severe corruption in the `cmpfloat` function's definition that caused compiler errors. The function was restored to its correct form.
- **`Problem_3/Makefile`**:
    - Configured to compile `merge_sort_MPI.c` into the `merge_sort_MPI` executable using `mpicc`.
- **`Problem_3/merge_sort_samenode.sbatch` & `merge_sort_diffnode.sbatch`**:
    - Updated `SBATCH` directives (e.g., `--chdir`, `--output`, `--error`, `--ntasks`, `--nodes`, `--ntasks-per-node`) for optimal Slurm job submission.
    - Replaced `srun` with `mpirun` for launching MPI jobs due to cluster-specific PMI support issues.

### Verification
- **Compilation & Execution**: Successfully compiled `merge_sort_MPI.c` and executed it via updated `sbatch` scripts on the Schooner cluster, generating the required `result_*.csv` and `time_*.csv` files in the `Problem_3/` directory.
- **Autograder**: The main autograder script (`run_autograder.sh`) correctly evaluated the generated data for Problem 3, confirming the accuracy and performance of the parallel merge sort implementation (all tests passed after fixing critical `fopen` and `cmpfloat` issues).

### Outcome
Problem 3 (Parallel Merge Sort) is fully implemented, configured for the Schooner cluster, and its correctness and performance have been successfully verified by the autograder. The generated data is ready for detailed analysis in the final report.
