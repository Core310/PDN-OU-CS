---
phase: 04-configuration-usability
plan: 01
subsystem: mining
tags: [configuration, block-size]
dependency_graph:
  requires: [01-01, 01-02, 02-01]
  provides: [CONF-01]
  affects: [Problem_1, Problem_2]
tech-stack: [CUDA, C++]
key-files:
  - Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu
  - Khor_Arika_Project_4/Problem_2/gpu_mining_starter.cu
decisions:
  - "Added an optional 6th command-line argument to specify the GPU thread block size."
  - "Maintained backward compatibility by defaulting to 1024 if the argument is omitted."
metrics:
  duration: "10m"
  completed_date: "2024-08-01"
---

# Phase 4 Plan 1: Mining Configuration Summary

## Objective
Enable configurable `BLOCK_SIZE` for the mining applications via command-line arguments.

## One-liner
Refactored Problem 1 and 2 to accept an optional block size argument, defaulting to 1024 for stability.

## Achievements
- **Command-line Parsing:** Updated `gpu_mining_starter.cu` in both Problem 1 and 2 to handle `argc == 7`.
- **Dynamic Scheduling:** Replaced the `BLOCK_SIZE` macro with a runtime variable used for grid and block dimension calculations.
- **Improved Usability:** Updated the usage message to guide users on how to provide the custom block size.

## Deviations from Plan
None.

## Self-Check: PASSED
- [x] Programs accept block size as 6th argument
- [x] Default remains 1024
- [x] Autograders pass
