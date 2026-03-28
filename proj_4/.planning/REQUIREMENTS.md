# Requirements

This document lists the functional and non-functional requirements for the CUDA Codebase Refactoring and Optimization project.

## Traceability

| Requirement | Description | Type | Phase | Status |
|---|---|---|---|---|
| **SETUP-01** | Establish a centralized directory for shared code | Non-Functional | 1 | Pending |
| **SETUP-02** | Refactor Makefiles to link against the shared code | Non-Functional | 1 | Pending |
| **RELY-01** | Implement a universal CUDA error-checking macro/function | Non-Functional | 1 | Pending |
| **RELY-02** | Apply error checking to all CUDA API calls in the codebase | Non-Functional | 1 | Pending |
| **PERF-01** | Implement a fully on-device parallel reduction algorithm | Functional | 2 | Pending |
| **PERF-02** | Replace the hybrid CPU/GPU reduction in the mining problem | Functional | 2 | Pending |
| **TEST-01** | Integrate Google Test (or similar) as the C++/CUDA unit testing framework | Non-Functional | 3 | Pending |
| **TEST-02** | Create unit tests for the GPU reduction kernel | Non-Functional | 3 | Pending |
| **TEST-03** | Create unit tests for the convolution kernel | Non-Functional | 3 | Pending |
| **CONF-01** | Replace hardcoded `BLOCK_SIZE` with a command-line argument | Non-Functional | 4 | Pending |
| **CONF-02** | Replace hardcoded convolution filter `RADIUS` with a command-line argument | Non-Functional | 4 | Pending |
| **CLEAN-01** | Remove all duplicated `support.h`, `support.cu` and serial code files | Non-Functional | 5 | Pending |

## v1 Requirements

### Setup and Structure (SETUP)

*   **SETUP-01:** The project structure must be refactored to include a common directory (e.g., `common/` or `lib/`) that contains code shared across multiple problems.
*   **SETUP-02:** The `Makefile`s for each problem must be updated to compile and link against the code in the common directory, removing the need for local copies.

### Reliability (RELY)

*   **RELY-01:** A single, robust CUDA error-checking macro or function must be defined in a shared header file. This utility should report the error, file, and line number upon failure.
*   **RELY-02:** Every CUDA API call (including `cudaMalloc`, `cudaMemcpy`, `cudaFree`, `cudaDeviceSynchronize`, and kernel launches) in all `.cu` files must be wrapped with the error-checking utility.

### Performance (PERF)

*   **PERF-01:** An efficient, multi-pass parallel reduction must be implemented entirely on the GPU. This should avoid device-to-host data transfers until the final result is ready.
*   **PERF-02:** The existing mining algorithm (Problem 1) must be modified to use the new, fully on-device parallel reduction for finding the minimum hash.

### Testing (TEST)

*   **TEST-01:** A standard C++ unit testing framework (like Google Test) must be integrated into the build system.
*   **TEST-02:** Unit tests must be written for the new parallel reduction kernel to verify its correctness with various input sizes (e.g., even, odd, powers of two).
*   **TEST-03:** Unit tests must be written for the convolution kernel to verify its correctness, potentially testing edge cases like 1x1 matrices or different radii.

### Configuration (CONF)

*   **CONF-01:** Hardcoded parameters like `BLOCK_SIZE` in the mining and reduction problems should be configurable via command-line arguments.
*   **CONF-02:** Hardcoded algorithm parameters like the convolution `RADIUS` should be configurable via command-line arguments.

### Cleanup (CLEAN)

*   **CLEAN-01:** After refactoring is complete, all duplicated source files from the individual `Problem_*/` directories must be deleted.
