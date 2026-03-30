# Codebase Concerns

**Analysis Date:** 2024-07-22

## Tech Debt

**Area/Component:** Inconsistent and Missing CUDA Error Handling
- **Issue:** The application of CUDA error checking is inconsistent across the project, and entirely absent in some critical files. This creates a significant risk of silent failures.
- **Files:**
  - `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`: Implements an `err_check` function but fails to apply it to several `cudaMalloc`, `cudaMemcpy`, and `cudaDeviceSynchronize` calls.
  - `Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu`: Contains zero checks for any CUDA API calls (`cudaMalloc`, `cudaMemcpy`, `cudaDeviceSynchronize`).
  - `Khor_Arika_Project_4/Problem_4/convolution_maxpooling.cu`: Also lacks CUDA error checking.
- **Impact:** If any CUDA API call fails (e.g., due to insufficient GPU memory, invalid arguments, or hardware errors), the program will not detect it. This can lead to undefined behavior, difficult-to-debug crashes, or silently incorrect results. The reliability of all GPU computations is compromised.
- **Fix approach:**
  1. Create a single, reusable CUDA error-checking macro or function (e.g., `CUDA_CHECK(err)`) in a shared `support.h` header.
  2. Refactor all `.cu` files to wrap every CUDA API call (`cudaMalloc`, `cudaMemcpy`, `cudaFree`, kernel launches, `cudaDeviceSynchronize`) with this macro. The macro should print the error message and location, then exit the program on failure.

**Area/Component:** Code Duplication Across "Problem" Directories
- **Issue:** The project is organized into separate directories for each "Problem" (`Problem_1`, `Problem_2`, etc.), which has led to widespread code duplication.
- **Files:**
  - `Khor_Arika_Project_4/Problem_3/serial/convolution_serial.c` and `Khor_Arika_Project_4/Problem_4/serial/convolution_serial.c` are identical.
  - `support.h`, `support.cu`, `Makefile`s, and kernel files (`kernel.cu`) are duplicated or slightly modified across `Problem_3` and `Problem_4`.
- **Impact:** Maintaining the code is difficult and error-prone. A bug fix or improvement made in one file must be manually identified and propagated to all its copies. This increases the chance of introducing inconsistencies.
- **Fix approach:**
  1. Establish a shared `src` or `common` directory for all common code, including serial implementations, support functions, and utility headers.
  2. Refactor the `Makefile`s in each `Problem` directory to link against these shared source files instead of using local copies.
  3. Remove the duplicated files from the individual problem directories.

**Area/Component:** Inefficient Parallel Reduction
- **Issue:** The reduction algorithm to find the minimum hash is implemented as a single GPU pass followed by a final reduction on the CPU.
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`
- **Impact:** This approach is a performance bottleneck. It requires transferring an intermediate array of minimums from the GPU to the CPU, which is slow. The final reduction is performed sequentially on the host, negating the benefits of the GPU for this part of the task, especially as the input size (and thus number of blocks) grows.
- **Fix approach:** Implement a full multi-pass reduction on the GPU. This can be done by repeatedly launching the reduction kernel with a progressively smaller grid size until only one block is needed, or by using a single, more complex kernel that can perform the full reduction. This avoids the costly device-to-host transfer.

## Security Considerations

**Area:** File Handling in C
- **Risk:** The project uses standard C file I/O (`fopen`, `fgets`) and string parsing (`strtok`) which are not inherently memory-safe.
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`, `Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu`
- **Current mitigation:** The file reading loops have some bounds checking (e.g., `i < n_transactions`). The `convolution_CUDA.cu` file uses a very large `MAX_LINE_LENGTH` buffer, which could be a risk if an input line ever exceeds it.
- **Recommendations:** For this academic project, the risk is low. However, for production code, using safer C++ alternatives like `std::ifstream` and `std::string` or ensuring meticulous bounds checking on all buffer operations would be recommended to prevent potential buffer overflows.

## Fragile Areas

**Component/Module:** Command-line Parsing
- **Files:** All main source files (e.g., `gpu_mining_starter.cu`, `convolution_CUDA.cu`).
- **Why fragile:** Argument parsing is done manually by checking `argc` and using `atoi`/`strtoul` on `argv` indices. This is brittle. If the order of arguments changes, the code breaks. There is no help message or validation beyond the argument count.
- **Safe modification:** Any changes to command-line arguments require carefully updating the index-based access in `main` and ensuring the usage message is also updated.
- **Test coverage:** No unit tests exist for argument parsing. It is only tested implicitly via the `autograder` scripts.

**Component/Module:** Hardcoded "Magic Numbers"
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`, `Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu`
- **Why fragile:** Key algorithm parameters are defined as hardcoded constants. `TARGET`, `MAX`, `BLOCK_SIZE` in the mining problem, and `RADIUS` and the filter matrix in the convolution problem are all inflexible. Changing these requires a recompile.
- **Safe modification:** Changes must be made directly in the source code. This makes it difficult to experiment with different parameters.
- **Test coverage:** Not applicable.

## Test Coverage Gaps

**Untested area:** All CUDA Kernels and C functions
- **What's not tested:** There is no unit testing framework (like Google Test) in place. No individual functions or CUDA kernels are tested in isolation.
- **Files:** All `.cu`, `.c`, and `.h` files.
- **Risk:** A bug in a single function (e.g., `padMatrix`, a CUDA kernel, or the `reduction_kernel`) can only be detected through a full end-to-end run. This makes pinpointing the source of errors difficult and time-consuming. It's impossible to test edge cases for a specific function without crafting a full input file and running the entire application.
- **Priority:** High. The lack of unit tests, combined with the missing error handling, makes the codebase very difficult to debug or safely modify.

---

*Concerns audit: 2024-07-22*
