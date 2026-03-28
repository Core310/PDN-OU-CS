# Coding Conventions

**Analysis Date:** 2024-07-29

## Naming Patterns

**Files:**
- C/CUDA source files use `snake_case` or `kebab-case` (e.g., `gpu_mining_starter.cu`, `serial_mining.c`).
- Header files use `snake_case` (e.g., `support.h`).
- Makefiles are named `Makefile`.
- Python test scripts are `snake_case` (e.g., `autograder_problem_4_1.py`).

**Functions:**
- C/CUDA functions use `snake_case` (e.g., `generate_hash`, `read_file`, `err_check`).

**Variables:**
- Local and global variables primarily use `snake_case` (e.g., `n_transactions`, `nonce_array`, `min_hash`).
- CUDA-specific dimension variables use `camelCase` (e.g., `dimGrid`, `dimBlock`).
- Pointers to device memory are often prefixed with `device_` (e.g., `device_nonce_array`).

**Types:**
- Standard C/CUDA integer types are used (e.g., `unsigned int`). No custom type definitions are prevalent.

**Constants / Macros:**
- Defined using `#define` and use `UPPER_SNAKE_CASE` (e.g., `DEBUG`, `BLOCK_SIZE`, `TARGET`).

## Code Style

**Formatting:**
- No automated formatting tool (like `clang-format` or `prettier`) is detected.
- Formatting is manual and can be inconsistent.
- **Braces:** Inconsistent style. Function definitions place the opening brace on a new line. Control structures (`if`, `for`) typically place the brace on the same line, but this is not always followed.
- **Indentation:** Appears to be 4-space indentation.
- **Spacing:** Logical blocks of code within functions are separated by multiple newlines and decorative comment blocks (e.g., `// -------- Start Mining -------- //`).

**Linting:**
- No linting tool (like `cpplint` or `clang-tidy`) is configured.
- The `Makefile` does not use warning flags like `-Wall` or `-Wextra`, so the compiler is not configured to enforce stricter code quality checks.

## Import Organization

**Order:**
- In `.c` and `.cu` files, headers are grouped at the top.
1. System and CUDA libraries (`<stdlib.h>`, `<cuda_runtime_api.h>`)
2. Local project headers (`"support.h"`)
3. Other source files are sometimes included directly (`#include "hash_kernel.cu"`), which acts as a simple module system.

**Path Aliases:**
- Not applicable for the C/CUDA code.

## Error Handling

**Patterns:**
- **Argument Parsing:** Command-line argument count is checked at the start of `main`. If incorrect, a usage message is printed to `stdout` and the program exits with `EXIT_FAILURE`.
- **File I/O:** `fopen` results are checked. On failure, an error is printed to `stderr` and the program exits.
- **CUDA Errors:** A dedicated wrapper function, `err_check`, is used to check the return value of all CUDA API calls (e.g., `cudaMalloc`, `cudaMemcpy`, `cudaDeviceSynchronize`). On error, it prints a descriptive message and the CUDA error string to `stderr` before exiting. This is a robust pattern.

## Logging

**Framework:**
- Logging is performed using `printf` to standard output. There is no formal logging framework.

**Patterns:**
- A `DEBUG` macro (`#define DEBUG 1`) is used to conditionally compile `printf` statements that display results and timing information to the console during a run. This acts as a simple way to toggle verbose output.

## Comments

**When to Comment:**
- Comments are used to describe the purpose of functions, explain constants, and label distinct logical sections within a function.
- `// TODO` comments are used to mark areas with incomplete functionality.

**JSDoc/TSDoc:**
- Not applicable. Function headers use a multi-line `/* ... */` block with a short description. Example:
```c
/* Generate Hash ----------------------------------------- //
*   Generates a hash value from a nonce and transaction list.
*/
```

## Function Design

**Size:**
- Functions are generally small and focused on a single responsibility (e.g., `read_file`, `generate_hash`).

**Parameters:**
- Pointers are used to pass arrays and for output parameters.

**Return Values:**
- `main` returns `0` on success and non-zero on failure.
- CUDA API error codes are captured and passed to a dedicated error-handling function.

## Module Design

**Exports:**
- Not applicable in the traditional sense. Functions are declared in headers (`.h` files) or via prototypes at the top of `.c` files to be used within that file.
- Some `.cu` files are directly included in others, effectively merging them at compile time.

**Barrel Files:**
- Not applicable.
---
*Convention analysis: 2024-07-29*
