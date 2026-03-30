# Architecture

**Analysis Date:** 2024-07-31

## Pattern Overview

**Overall:** Host-Device GPGPU (General-Purpose computing on Graphics Processing Units)

**Key Characteristics:**
- **Heterogeneous Computing:** The application logic is split between the CPU (host) and the GPU (device). The CPU handles serial tasks like I/O, control flow, and setup, while the GPU performs massively parallel computations.
- **CUDA Programming Model:** The project uses NVIDIA's CUDA framework to write C/C++ code that can execute on the GPU.
- **Explicit Data Management:** The host code is responsible for explicitly allocating memory on the GPU, transferring data between host and device, and deallocating memory. This is a defining characteristic of the CUDA programming model.

## Layers

**Host/Driver Layer:**
- **Purpose:** Orchestrates the entire computation. Reads input data, manages GPU memory, launches kernels, and writes output data.
- **Location:** `.cu` files containing the `main` function (e.g., `Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu`).
- **Contains:** C/C++ code for I/O, memory management (`cudaMalloc`, `cudaMemcpy`, `cudaFree`), and kernel launch syntax (`<<<...>>>`).
- **Depends on:** CUDA Runtime API, Support Layer.
- **Used by:** The user, via command-line execution of the compiled binary.

**Device/Kernel Layer:**
- **Purpose:** Executes the computationally intensive parallel algorithms.
- **Location:** `.cu` files containing `__global__` functions (e.g., `Khor_Arika_Project_4/Problem_3/kernel.cu`, `Khor_Arika_Project_4/Problem_1/hash_kernel.cu`).
- **Contains:** CUDA kernels that define the logic for a single thread. Utilizes the CUDA thread hierarchy (`blockIdx`, `threadIdx`).
- **Depends on:** Nothing (it is the base computational unit).
- **Used by:** The Host/Driver Layer, which launches it.

**Support Layer:**
- **Purpose:** Provides reusable helper functions for tasks common across different problems, such as timing and error handling.
- **Location:** `Khor_Arika_Project_4/Problem_*/support.h`, `Khor_Arika_Project_4/Problem_*/support.cu`.
- **Contains:** Functions for starting/stopping timers (`startTime`, `stopTime`) and handling CUDA errors.
- **Depends on:** CUDA Runtime API.
- **Used by:** The Host/Driver Layer.

**Serial/Reference Layer:**
- **Purpose:** Provides a sequential, CPU-only implementation of the same algorithm. This is used for correctness verification and performance comparison.
- **Location:** `Khor_Arika_Project_4/Problem_*/serial/` directories (e.g., `serial_mining.c`).
- **Contains:** Standard C code.
- **Depends on:** Standard C libraries.
- **Used by:** Developers for testing and benchmarking.

## Data Flow

**Typical GPU Computation Flow (e.g., Convolution):**

1.  **Host:** The `main` function in `convolution_CUDA.cu` is executed on the CPU.
2.  **Host:** Input data (e.g., a matrix) is read from a file (`input.csv`) into host RAM using `malloc` and standard file I/O.
3.  **Host:** GPU device memory is allocated using `cudaMalloc`.
4.  **Host -> Device:** The input data is copied from host RAM to GPU VRAM using `cudaMemcpy(..., cudaMemcpyHostToDevice)`.
5.  **Host:** The host launches the `convolution_kernel<<<...>>>` on the GPU, passing device pointers as arguments. The CPU can continue other tasks or wait.
6.  **Device:** The GPU executes the `convolution_kernel` in parallel across thousands of threads. Threads may use `__shared__` memory for optimized data access (tiling).
7.  **Host:** The host calls `cudaDeviceSynchronize()` to block and wait until the GPU kernel has finished execution.
8.  **Device -> Host:** The computed result is copied from GPU VRAM back to host RAM using `cudaMemcpy(..., cudaMemcpyDeviceToHost)`.
9.  **Host:** The host writes the result from RAM to an output file (`results.csv`).
10. **Host:** Both host (`free`) and device (`cudaFree`) memory are deallocated.

## Key Abstractions

**CUDA Kernel:**
- **Purpose:** Represents the core parallel algorithm. It's a C-style function that is executed by many GPU threads simultaneously.
- **Examples:** `__global__ void convolution_kernel(...)` in `Khor_Arika_Project_4/Problem_3/kernel.cu`.
- **Pattern:** Prefixed with `__global__`. Launched from the host using `<<<...>>>` syntax.

**Shared Memory Tiling:**
- **Purpose:** An optimization pattern to reduce slow global VRAM access. Data is cooperatively loaded by a block of threads into fast, on-chip shared memory, computed on, and then written back.
- **Examples:** The use of `__shared__ int tile_s[...]` and `__shared__ int filter_s[...]` in `Khor_Arika_Project_4/Problem_3/kernel.cu`.
- **Pattern:** Declare variables with `__shared__`, load data from global to shared memory, synchronize threads with `__syncthreads()`, compute using shared memory.

## Error Handling

**Strategy:** Explicit return code checking.

**Patterns:**
- The CUDA Runtime API functions (e.g., `cudaMalloc`) return an error code of type `cudaError_t`.
- The `support.h` file likely contains a macro (e.g., `FATAL` or a custom error-checking wrapper, though not fully shown in provided files) that checks this return value. If the value is not `cudaSuccess`, it prints an error message and terminates. This is a standard pattern in CUDA applications.

---

*Architecture analysis: 2024-07-31*
