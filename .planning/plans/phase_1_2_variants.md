# Plan: Phase 1.2 - Atomic, Locks, and Schedule Variants

## Objective
Implement the remaining three variants for Problem 2.

## Tasks
1. [ ] **Atomic Variant**:
    - Copy `critical.c` to `compute_average_TF_Exp1_atomic.c`.
    - Replace critical section with `#pragma omp atomic` loop in `aggregate_results_atomic`.
2. [ ] **Locks Variant**:
    - Copy `critical.c` to `compute_average_TF_Exp1_locks.c`.
    - Implement `aggregate_results_locks` using `omp_set_lock`.
    - Add lock initialization and destruction in `main`.
3. [ ] **Schedule Variant**:
    - Copy `critical.c` to `compute_average_TF_Exp2_schedule.c`.
    - Add `schedule(runtime)` to the parallel for loop.

## Verification
- Successful compilation of all three new files.
