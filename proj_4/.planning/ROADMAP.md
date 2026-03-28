# Project Roadmap

This roadmap outlines the phased approach to refactoring and improving the CUDA project codebase.

## Phases

- [x] **Phase 1: Foundational Refactoring** - Establish a clean, non-redundant code structure and implement robust error handling.
- [x] **Phase 2: Algorithm Optimization** - Improve the performance of a key parallel algorithm.
- [ ] **Phase 3: Unit Testing Integration** - Introduce a testing framework and create a safety net for kernels.
- [ ] **Phase 4: Configuration and Usability** - Eliminate hardcoded values to improve flexibility.
- [ ] **Phase 5: Finalization and Validation** - Ensure all refactoring goals are met and remove dead code.

## Progress

| Phase | Plans Complete | Status | Completed |
|---|---|---|---|
| 1. Foundational Refactoring | 2/2 | Completed | 2024-08-01 |
| 2. Algorithm Optimization | 1/1 | Completed | 2024-08-01 |
| 3. Unit Testing Integration | 2/2 | Completed | 2024-08-01 |
| 4. Configuration and Usability | 3/3 | Completed | 2024-08-01 |
| 5. Finalization and Validation | 1/1 | Completed | 2024-08-01 |


## Phase Details

### Phase 1: Foundational Refactoring
**Goal:** To create a stable and reliable foundation by centralizing shared code and ensuring all errors are caught.
**Depends on:** Nothing
**Requirements:** SETUP-01, SETUP-02, RELY-01, RELY-02
**Plans:** 2 plans
- [x] `01-01-PLAN.md` — Consolidate duplicated `support` code into a `common` directory.
- [x] `01-02-PLAN.md` — Integrate `common` code into build system and add unified error handling.
**Success Criteria:**
  1. A `common` directory exists containing a single copy of `support.h`/`.cu` and other shared files.
  2. All `Problem_*` Makefiles link to the common files; the project still compiles and runs correctly.
  3. A single CUDA error-checking macro is defined in `common/support.h`.
  4. Executing the programs with invalid parameters (e.g., asking for too much GPU memory) causes a graceful exit with a clear error message, rather than a silent failure or crash.

### Phase 2: Algorithm Optimization
**Goal:** To significantly improve performance by implementing an efficient parallel reduction on the GPU.
**Depends on:** Phase 1
**Requirements:** PERF-01, PERF-02
**Plans:** 1 plan
- [x] `02-01-PLAN.md` — Implement a fully on-device parallel reduction using atomic operations.
**Success Criteria:**
  1. A new GPU kernel exists that performs a full reduction without needing an intermediate CPU step.
  2. The mining application (Problem 1) now uses this new kernel.
  3. The end-to-end time for the mining problem is demonstrably faster than the original implementation, especially for large input sizes.
  4. The optimized mining problem still produces the correct output as verified by the autograder.

### Phase 3: Unit Testing Integration
**Goal:** To improve code quality and developer confidence by introducing a unit testing framework.
**Depends on:** Phase 1
**Requirements:** TEST-01, TEST-02, TEST-03
**Plans:** 2 plans
- [ ] `03-01-PLAN.md` — Initialize Google Test framework and implement reduction kernel unit tests.
- [ ] `03-02-PLAN.md` — Implement convolution kernel unit tests and integrate into a unified build target.
**Success Criteria:**
  1. The build system has a new target (e.g., `make test`) that compiles and runs unit tests.
  2. A developer can run a test that validates only the reduction kernel's logic without running the entire mining application.
  3. A developer can run a test that validates only the convolution kernel's logic.
  4. The test suite is clean and reports success for the newly created tests.

### Phase 4: Configuration and Usability
**Goal:** To make the application more flexible by replacing hardcoded "magic numbers" with command-line arguments.
**Depends on:** Phase 1
**Requirements:** CONF-01, CONF-02
**Success Criteria:**
  1. A user can run the convolution program and specify the filter radius from the command line.
  2. A user can run the mining/reduction programs and specify the thread block size from the command line.
  3. Running the programs with no arguments or `--help` prints a usage message explaining the new parameters.
  4. The autograder scripts are updated to use the new command-line arguments and still pass.

### Phase 5: Finalization and Validation
**Goal:** To complete the refactoring by removing all remaining duplicated code and verifying project integrity.
**Depends on:** Phase 4
**Requirements:** CLEAN-01
**Success Criteria:**
  1. A search for `support.h` in the project returns only one file (in the `common` directory).
  2. All `Problem_*/serial/` directories are removed, and a central `serial/` directory provides the reference implementations.
  3. The entire project compiles cleanly.
  4. All autograders and unit tests pass successfully.
