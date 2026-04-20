# Project 5: MPI Programming

## Overview
This project involves implementing and analyzing several parallel algorithms using the Message Passing Interface (MPI) standard. The goal is to understand MPI communication costs, collective operations, and parallel sorting techniques.

## Objectives
- **Problem 1: Ping-Pong Communication:** Measure MPI communication latency and bandwidth by bouncing an array between two processes.
- **Problem 2: Parallel Dot Product:** Implement a parallel dot product using MPI collective communication (`MPI_Scatter`, `MPI_Reduce`).
- **Problem 3: Parallel Merge Sort:** Implement a parallel merge sort using a tree-based reduction/merge pattern.
- **Problem 4: Monte Carlo Pi Estimation:** Estimate the value of Pi using a parallel Monte Carlo method (Graduate Requirement).

## Technical Stack
- **Language:** C
- **Parallel Framework:** MPI (Message Passing Interface)
- **Compilers:** GCC, Intel (on Schooner)
- **Environment:** Schooner Supercomputer (SLURM sbatch)

## Constraints & Requirements
- **Minimalism:** No single-line comments (`//`).
- **Documentation:** Use multi-line block comments (`/* ... */`) for logic sections and requirements.
- **Traceability:** Logic derived from project instructions MUST include a comment quoting the exact wording and page number from `Project_5_Instructions.pdf`.
- **Modularity:** Maintain the `setup/` module for all shared logic (if needed).
- **CLI/IO:** Strict CLI arguments as specified in instructions.
- **Output Precision:** Frequencies/Times should use `%.6f` or as specified.

## Graduate Requirements
- Problem 4 is required for graduate students (CS5473).
