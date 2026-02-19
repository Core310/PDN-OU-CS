# Roadmap for Project 3

## Phase 1: Problem 2 (Average TF)
- [x] Implement sliding window logic in `process_tetranucs` (A=0, C=1, G=2, T=3).
- [x] Implement `Exp1_critical`: Mutual exclusion via `#pragma omp critical`.
- [x] Implement `Exp1_atomic`: Mutual exclusion via `#pragma omp atomic`.
- [x] Implement `Exp1_locks`: Mutual exclusion via an array of 256 `omp_lock_t`.
- [x] Implement `Exp2_schedule`: Load balancing via `schedule` clauses.
- [x] Update Makefile and verify compilation.

## Phase 2: Problem 3 (Median TF)
- [x] Implement TF storage in a 2D array (`num_genes` x 256).
- [x] Implement `Exp1_baseline`: Parallel gene processing + serial median calculation.
- [x] Implement `Exp2_mapreduce`: Parallel gene processing + parallel median calculation (one thread per TF index).
- [x] Update Makefile and verify compilation.

## Phase 3: Problem 4 (K-means Clustering)
- [ ] Implement serial K-means logic (Euclidean distance, centroid update).
- [ ] Parallelize point assignment (Map phase).
- [ ] Parallelize centroid updates using thread-local sums (Reduce phase).
- [ ] Apply `default(none)` and optimize scheduling.
- [ ] Update Makefile and verify compilation.

## Phase 4: Build System Consolidation
- [ ] Standardize Makefiles across all problems.
- [ ] Ensure `make all` and `make clean` work for all targets.

## Phase 5: Report Generation
- [ ] Create `Khor_Arika_Project_3_Report.md` in Project 2 format.
- [ ] Write algorithm and parallel strategy descriptions.
- [ ] Prepare empty result tables for runtime, speedup, and efficiency.
