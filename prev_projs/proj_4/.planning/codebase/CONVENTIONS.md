# Coding Conventions

**Analysis Date:** 2024-07-25

## Naming Patterns

**Files:**
- Python scripts use `snake_case.py` (e.g., `autograder_problem_4_1.py`).
- C/CUDA source files use `snake_case.c` or `snake_case.cu` (e.g., `gpu_mining_starter.cu`).
- Makefiles are named `Makefile`.

**Functions:**
- Python functions and methods use `snake_case` (e.g., `autograde()`).
- C/CUDA functions use `snake_case` (e.g., `read_file`, `err_check`).
- CUDA kernels are distinguished by a `_kernel` suffix (e.g., `generate_hash_kernel`).

**Variables:**
- Python variables use `snake_case` (e.g., `student_name`).
- C/CUDA variables primarily use `snake_case` (e.g., `n_transactions`).
- C/CUDA pointer variables are sometimes prefixed with `d_` (device) or `h_` (host) to denote memory space (e.g., `d_min_hash_out`).
- Constants in both languages use `UPPERCASE_SNAKE_CASE` (e.g., `BLOCK_SIZE`, `DEBUG`).

**Types:**
- Python classes use a modified `PascalCase` with an underscore (e.g., `Autograder_4_1`). The standard convention is `PascalCase` without underscores.

## Code Style

**Formatting:**
- No automated formatter (like Black or Prettier) is detected.
- Python code is generally well-formatted, using 4-space indentation.
- C/CUDA code has inconsistent brace styling. Opening braces for functions are on a new line, while for control structures (`if`, `for`) they are on the same line.

**Linting:**
- No linter configuration (like `.eslintrc` or `flake8`) is detected.
- Python code uses f-strings for formatting and `os.path.join` for path construction, which are modern best practices.

## Import Organization

**Order:**
- In Python files, imports are grouped at the top of the file, with standard library modules first.
- Example from `Khor_Arika_Project_4/autograder_problem_4_1.py`:
  ```python
  import numpy as np
  import os
  import pandas as pd
  import sys
  ```

**Path Aliases:**
- No path aliases (like `@/` or `~/`) are used. Relative paths are used for local project imports (e.g., `sys.path.append("..")`).

## Error Handling

**Patterns:**
- **Python:** Error handling is minimal. The autograder scripts do not use `try...except` blocks and appear to assume that file paths are valid and commands will execute.
- **C/CUDA:** A robust, explicit error-handling pattern is used for CUDA API calls. A wrapper function, `err_check`, is used after each CUDA call to check the return status, print a detailed error message, and exit on failure.
  - Example from `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`:
    ```c++
    void err_check(cudaError_t ret, char* msg, int exit_code) {
        if (ret != cudaSuccess)
            fprintf(stderr, "%s "%s".
", msg, cudaGetErrorString(ret)),
            exit(exit_code);
    }
    
    // Usage
    cuda_ret = cudaMalloc((void**)&device_nonce_array, trials * sizeof(unsigned int));
    err_check(cuda_ret, (char*)"Unable to allocate nonces to device memory!", 1);
    ```

## Logging

**Framework:**
- No formal logging framework is used.
- Output is printed directly to `stdout` and `stderr` using `print()` in Python and `printf()`/`fprintf()` in C/CUDA.
- The Python scripts use ANSI escape codes for colored output.

## Comments

**When to Comment:**
- Comments are used to explain non-obvious steps or to structure sections of code.
- In C/CUDA, large blocks of functionality in `main` are delineated by comments (e.g., `// ------ Step 1: generate the nonce values ------ //`).

**JSDoc/TSDoc:**
- Not applicable. Docstrings are largely absent from Python code.
- C/CUDA functions have multi-line block comments explaining their purpose.
  - Example from `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`:
  ```c++
  /* Read File -------------------- //
  *   Reads in a file of transactions. 
  */
  void read_file(...)
  ```

## Module Design

**Exports:**
- Python modules use classes (`Autograder_4_1`) that are instantiated and run via a `main` function guard (`if __name__ == "__main__":`).
- C/CUDA code is structured as single executables.

**Barrel Files:**
- Not used.

**Special Note: CUDA Includes**
- The project uses `#include "some_kernel.cu"` to include CUDA kernel definitions directly into the main `.cu` file. This is unconventional. Typically, kernel definitions are in their own compilation units and their declarations are placed in header files (`.h`), which are then included. This approach simplifies the build process for a small project but is not scalable.

---

*Convention analysis: 2024-07-25*
