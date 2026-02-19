# Roadmap for Project 3

## Phase 1: Problem 2 (Average TF)
- [x] Implement sliding window logic in `setup` module.
- [x] Implement `Exp1_critical`: Mutual exclusion via `#pragma omp critical`.
- [x] Implement `Exp1_atomic`: Mutual exclusion via `#pragma omp atomic`.
- [x] Implement `Exp1_locks`: Mutual exclusion via an array of 256 `omp_lock_t`.
- [x] Implement `Exp2_schedule`: Load balancing via `schedule` clauses.
- [x] Update Makefile and verify compilation.

## Phase 2: Problem 3 (Median TF)
- [x] Implement flat 1D array TF storage for contiguous memory access.
- [x] Implement `Exp1_baseline`: Parallel gene processing + serial median calculation.
- [x] Implement `Exp2_mapreduce`: Parallel gene processing + parallel median calculation (one thread per TF index).
- [x] Update Makefile and verify compilation.

## Phase 3: Problem 4 (K-means Clustering)
- [x] Implement serial K-means logic (Euclidean distance, centroid update).
- [x] Parallelize point assignment (Map phase) using squared distance.
- [x] Parallelize centroid updates using thread-local sums (Reduce phase) to avoid false sharing.
- [x] Apply strict 7-arg CLI and convergence threshold <= 1.0.
- [x] Update Makefile and verify compilation.

## Phase 4: Build System Consolidation
- [x] Create root Makefile to build all problems with one command.
- [x] Standardize all Makefiles with `-O3`, `-fopenmp`, and `-lm`.
- [x] Ensure `make all` and `make clean` work for all targets.

## Phase 5: Report Generation
- [x] Create `Khor_Arika_Project_3_Report.md` in Project 2 format.
- [x] Write detailed algorithm and parallel strategy descriptions.
- [x] Prepare empty result tables for runtime, speedup, and efficiency.
