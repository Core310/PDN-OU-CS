# UAT: Phase 1 (Problem 2 - Average TF)

## Feature: Modular Architecture & Compilation
**Test 1: Build Verification**
- [x] Problem 2 Makefile correctly links against shared `setup.c`.
- [x] All 5 variants (`starter`, `critical`, `atomic`, `locks`, `schedule`) compile without errors.
- [x] Compilation uses required flags: `-O3 -fopenmp`.

## Feature: CLI & Requirement Compliance
**Test 2: Argument Enforcement**
- [x] Each binary correctly requires exactly 5 arguments.
- [x] Each binary prints the specified "USE LIKE THIS" message on failure.

**Test 3: Documentation Traceability**
- [x] Source files contain multi-line comments quoting Page 7 requirements.
- [x] No single-line comments exist in the code.
