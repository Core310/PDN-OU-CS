---
phase: 04-configuration-usability
plan: 02
subsystem: convolution
tags: [configuration, shared-memory, radius]
dependency_graph:
  requires: [01-01, 01-02, 03-01, 03-02]
  provides: [CONF-02]
  affects: [Problem_3, Problem_4]
tech-stack: [CUDA, C++]
key-files:
  - Khor_Arika_Project_4/Problem_3/kernel.cu
  - Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu
  - Khor_Arika_Project_4/Problem_4/convolution_maxpooling.cu
decisions:
  - "Refactored convolution and max-pooling kernels to use dynamic shared memory (`extern __shared__`) to support runtime-configurable block sizes and radii."
  - "Updated host-side padding and filter initialization to handle variable radii, defaulting to the canonical 5x5 'X' pattern when radius is 2."
metrics:
  duration: "20m"
  completed_date: "2024-08-01"
---

# Phase 4 Plan 2: Convolution Configuration Summary

## Objective
Enable configurable `BLOCK_SIZE` and `RADIUS` for the convolution and max-pooling applications.

## One-liner
Migrated convolution kernels to dynamic shared memory and added command-line control for tile size and filter radius.

## Achievements
- **Dynamic Shared Memory:** Successfully eliminated static shared memory allocations in `convolution_kernel`. The kernel now partitions a single `extern __shared__` array into `filter_s` and `tile_s` at runtime.
- **Variable Radius Support:** Updated `padMatrix` and filter initialization logic to respect the user-provided radius.
- **Max-pooling Optimization:** Refactored `maxpooling_kernel` to accept radius as a parameter, enabling max-pooling windows of various sizes.
- **Usage Guidance:** Enhanced the CLI usage message to include the optional [BLOCK_SIZE] and [RADIUS] parameters.

## Deviations from Plan
- **Shared Memory Loading Fix:** Identified and corrected a coordinate offset error in the tile loading logic where `radius` was being subtracted twice, resulting in incorrect halo data.

## Self-Check: PASSED
- [x] Kernels use dynamic shared memory
- [x] Host-side respects RADIUS argument
- [x] Default values (16, 2) pass autograder
