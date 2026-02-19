# UAT: Phase 2 (Problem 3 - Median TF)

## Feature: Modular Architecture & Compilation
**Test 1: Build Verification**
- [x] Problem 3 Makefile correctly links against shared `setup.c`.
- [x] All 3 variants (`starter`, `baseline`, `mapreduce`) compile without errors.
- [x] Compilation uses required flags: `-O3 -fopenmp`.

## Feature: CLI & Requirement Compliance
**Test 2: Argument Enforcement**
- [x] Each binary correctly requires exactly 5 arguments.

**Test 3: Documentation Traceability**
- [x] `mapreduce.c` contains multi-line comments quoting Page 10 requirements.
- [x] No single-line comments exist in the code.
