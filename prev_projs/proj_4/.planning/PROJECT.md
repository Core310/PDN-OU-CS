# Project: CUDA Codebase Refactoring and Optimization

**Core Value Proposition:** This project aims to transform a collection of functional but brittle CUDA programs into a robust, maintainable, and high-performance application suite. The primary goal is to address significant technical debt, improve reliability, and establish a foundation for future development by refactoring the existing codebase.

**Success Definition:** The project will be considered successful when all identified technical debt is resolved, the codebase is structurally sound with centralized common code, performance bottlenecks are eliminated, and a testing framework is in place to ensure future changes can be made safely.

## Project Scope

### In Scope:

*   **Codebase Refactoring:**
    *   Centralizing duplicated code (e.g., support functions, serial implementations) into a shared library.
    *   Updating the build system (`Makefile`s) to support the new shared structure.
*   **Reliability and Error Handling:**
    *   Implementing a consistent, project-wide CUDA error-handling mechanism that wraps all runtime API calls.
*   **Performance Optimization:**
    *   Implementing an efficient, multi-pass parallel reduction algorithm on the GPU to replace the current inefficient hybrid approach.
*   **Testing:**
    *   Integrating a C/C++ unit testing framework (e.g., Google Test).
    *   Writing initial unit tests for critical CUDA kernels (e.g., reduction, convolution).
*   **Configuration and Usability:**
    *   Replacing hardcoded "magic numbers" in algorithms with configurable command-line arguments.

### Out of Scope:

*   Adding new computational problems beyond the existing four (Mining, Reduction, Convolution, Max Pooling).
*   Changing the core algorithms themselves, except for the GPU reduction which is explicitly targeted for optimization.
*   Building a graphical user interface (GUI).
*   Porting the application to non-NVIDIA hardware (e.g., AMD ROCm or OpenCL).
*   Modifying the Python-based autograding scripts, other than to adjust for new command-line arguments.
