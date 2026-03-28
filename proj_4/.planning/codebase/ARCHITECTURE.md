# Architecture

**Analysis Date:** 2024-07-25

## Pattern Overview

**Overall:** CPU-GPU Offloading for Scientific Computing

The project is not a single application but a collection of four distinct computational problems. The primary architectural pattern is the use of a General-Purpose GPU (GPGPU) to accelerate computationally intensive, data-parallel tasks.

**Key Characteristics:**
- **Heterogeneous Computing:** The system uses both the CPU (host) and a GPU (device) for computation.
- **Parallelism:** Tasks are parallelized across thousands of GPU threads to achieve speedup over traditional serial CPU execution.
- **Problem-Oriented:** The architecture is structured around solving specific, isolated computational problems (e.g., cryptocurrency mining, image convolution). Each problem exists as a self-contained unit.

## Layers

The architecture does not follow a traditional multi-tiered pattern (e.g., UI/Business/Data). Instead, it's a two-part system within each problem.

**Host (CPU):**
- **Purpose:** Orchestrates the overall process, handles I/O (file reading/writing), manages GPU memory, and executes serial parts of the computation.
- **Location:** `Khor_Arika_Project_4/Problem_*/` (e.g., `gpu_mining_starter.cu`, `convolution.cu`) and `Khor_Arika_Project_4/Problem_*/serial/` (e.g., `serial_mining.c`).
- **Contains:** The `main` function, file I/O logic, CUDA API calls for memory management (`cudaMalloc`, `cudaMemcpy`), and kernel launch configuration.
- **Depends on:** CUDA runtime libraries.
- **Used by:** The user or an execution script (`Makefile`, `.sbatch`).

**Device (GPU):**
- **Purpose:** Executes massively parallel computations.
- **Location:** Kernels are defined in `.cu` files (e.g., `nonce_kernel.cu`, `hash_kernel.cu`) and launched from the host code.
- **Contains:** CUDA kernels (`__global__` functions) that define the logic to be executed by each GPU thread.
- **Depends on:** Data provided by the host.
- **Used by:** The host code, which launches the kernels.

## Data Flow

**Typical Data Flow (Problem 1 - Mining):**

1.  **Host (CPU):** The `main` function in `gpu_mining_starter.cu` is invoked. It reads command-line arguments and loads transaction data from a `.csv` file into host memory.
2.  **Host -> Device (CPU -> GPU):** The host allocates memory on the GPU device using `cudaMalloc`.
3.  **Device (GPU):** The host launches the `nonce_kernel` on the GPU. Thousands of threads execute in parallel, each generating a unique nonce and writing it to the GPU memory allocated in the previous step.
4.  **Device -> Host (GPU -> CPU):** The host calls `cudaMemcpy` to copy the array of generated nonces from GPU memory back to host memory.
5.  **Host (CPU):** The host code iterates through the nonces to generate hashes and find the minimum value. *(Note: The `TODO` comments in the code indicate this step is intended to be moved to the GPU as well).*
6.  **Host (CPU):** The final result (the nonce corresponding to the minimum hash) is written to output files.

## Key Abstractions

**CUDA Kernel:**
- **Purpose:** A function that runs on the GPU and is executed by many threads in parallel. It is the core unit of parallel computation.
- **Examples:** `nonce_kernel` in `Khor_Arika_Project_4/Problem_1/nonce_kernel.cu`.
- **Pattern:** Declared with `__global__ void`. Launched from the host using the `<<<grid, block>>>` syntax.

**Host/Device Memory Management:**
- **Purpose:** Explicit management of memory on the CPU's RAM (host) and the GPU's VRAM (device). Data must be manually transferred between the two.
- **Examples:** `cudaMalloc`, `cudaMemcpy`, `cudaFree` calls within `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`.
- **Pattern:** Allocate on device (`cudaMalloc`), copy from host (`cudaMemcpyHostToDevice`), compute, copy back to host (`cudaMemcpyDeviceToHost`), free on device (`cudaFree`).

## Entry Points

**Primary Entry Point (GPU version):**
- **Location:** The `main` function inside the primary `.cu` file for each problem (e.g., `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`).
- **Triggers:** Executed via a `Makefile` target (e.g., `make run`) or a SLURM batch script (`.sbatch`).
- **Responsibilities:** Overall orchestration of the CPU-GPU workflow: data loading, memory transfers, kernel launches, and result output.

**Comparison Entry Point (Serial version):**
- **Location:** The `main` function inside the C file in the `serial/` subdirectory (e.g., `Khor_Arika_Project_4/Problem_1/serial/serial_mining.c`).
- **Triggers:** Executed via its own `Makefile`.
- **Responsibilities:** Performs the same logic as the GPU version but entirely on the CPU in a serial manner.

## Error Handling

**Strategy:** Manual, explicit error checking after CUDA API calls.

**Patterns:**
- The `cudaError_t` return value from every major CUDA API call (e.g., `cudaMalloc`, `cudaMemcpy`, `cudaDeviceSynchronize`) is checked.
- A utility function, `err_check`, is used to wrap this logic. If the return value is not `cudaSuccess`, it prints a descriptive error message along with the official error string from `cudaGetErrorString` and terminates the program.

---

*Architecture analysis: 2024-07-25*
