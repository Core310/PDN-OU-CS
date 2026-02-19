# Plan: Phase 1.1 - Core Logic and Critical Variant

## Objective
Implement the core TF calculation logic and the first parallel variant using `#pragma omp critical`.

## Context
- Binary: `compute_average_TF_Exp1_critical`
- Source: `Project_3_Problems/Khor_Arika_Project_3/Problem_2/compute_average_TF_Exp1_critical.c`
- Input: `.fna` file
- Output: `average_TF.csv` (%.6f), `time.csv` (raw seconds)

## Tasks
1. [ ] Copy starter file to `compute_average_TF_Exp1_critical.c`.
2. [ ] Implement `process_tetranucs` with sliding window (size 4) and error handling for non-ACGT/short sequences.
3. [ ] Implement `aggregate_results_critical` function.
4. [ ] Implement `main` with 5-arg CLI parsing and error handling for malloc/missing headers.
5. [ ] Implement parallel gene loop with `critical` aggregation.

## Verification
- Successful compilation with `gcc -fopenmp -O3`.
