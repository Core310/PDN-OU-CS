# Project 4 Report: Tree Reduction and Stencil Computation in GPU

**Name:** [Student Name]  
**Course:** CS5473  
**Date:** March 27, 2026

---

## 1. Introduction
This project focuses on the implementation and optimization of three common parallel computing patterns on the GPU using CUDA:
1.  **Embarrassingly Parallel:** Cryptocurrency mining hash generation.
2.  **Tree Reduction:** Global minimum search for finding the winning nonce.
3.  **Stencil Computation:** 2D convolution and max-pooling for image processing.

The primary objective was to offload compute-intensive operations from the CPU to the GPU and optimize data transfers to maximize performance.

### Project Layout
The submission is structured as follows to ensure modularity and ease of verification:

*   **`common/`**: Contains shared utility code, including the centralized `support.h` and `support.cu` used for timing and the unified `gpuErrchk` error-handling macro.
*   **`Problem_1/`**: Implementation of the mining application with GPU-based hash generation and CPU-based minimum search.
*   **`Problem_2/`**: Optimized mining application utilizing a fully on-device 64-bit atomic tree reduction.
*   **`Problem_3/`**: 2D convolution implementation using shared memory tiling and dynamic runtime configuration.
*   **`Problem_4/`**: Integrated pipeline combining convolution and max-pooling operations on the GPU.
*   **`serial/`**: Centralized reference implementations for mining, convolution, and max-pooling used for correctness validation.
*   **`autograder_*.py`**: Stabilized Python scripts for automated grading and verification of all problems.

---

## 2. Problem 1: GPU-Accelerated Hash Generation

### Technical Approach
In Problem 1, Step 1 (Nonce generation) and Step 2 (Hash calculation) were offloaded to the GPU. The Step 3 (Minimum search) remained on the CPU.

*   **Hash Kernel:** I implemented `hash_kernel.cu` which assigns one GPU thread to each trial. Each thread calculates a hash value based on a randomly generated nonce and a block of 20,000 transactions using modular arithmetic.
*   **Data Flow:**
    1.  The transaction array is copied from Host to Device (H2D) once.
    2.  Nonces are generated on-device and kept in global memory.
    3.  The `generate_hash_kernel` produces a `hash_array` on the device.
    4.  **Bottleneck:** The entire `hash_array` (millions of elements) is copied back to the Host (D2H) for the CPU to find the minimum.

### Benchmarking (Problem 1)
| Metric | 5 Million Trials | 10 Million Trials |
| :--- | :--- | :--- |
| Runtime (Wall-clock) | 0.678518s | 1.131965s |
| Status | Passed | Passed |

---

## 3. Problem 2: Fully Parallel GPU Reduction

### Technical Approach
Problem 2 optimizes the mining application by offloading the minimum search (Step 3) to the GPU, eliminating the massive Data-to-Host transfer and the serial CPU loop.

*   **64-bit Atomic Packing:** To find both the minimum hash *and* its corresponding nonce together, I utilized a packed 64-bit `unsigned long long`. The hash value is stored in the upper 32 bits, and the nonce in the lower 32 bits.
*   **Tree Reduction Kernel:** I implemented a two-stage approach:
    1.  **Intra-block Reduction:** Each block uses shared memory to find its local minimum hash/nonce pair using a tree-based comparison.
    2.  **Global Atomic Update:** The thread 0 of each block performs an `atomicCAS` (Compare-And-Swap) on a single global 64-bit memory location. Because the hash is in the upper bits, the atomic comparison correctly identifies the global minimum based on the hash value first.
*   **Optimization:** This implementation reduces the Device-to-Host transfer from ~40MB (for 10M trials) down to exactly 8 bytes.

### Benchmarking (Problem 2)
| Metric | 5 Million Trials | 10 Million Trials |
| :--- | :--- | :--- |
| Runtime (Wall-clock) | 0.632880s | 1.087014s |
| Speedup over Problem 1 | **~7%** | **~4%** |

*Note: While the kernel itself is much faster, the total wall-clock speedup is limited by the fixed overhead of kernel launches and transaction file I/O for these trial sizes.*

---

## 4. Problem 3: Tiled 2D Convolution

### Technical Approach
Implemented a GPU-accelerated convolution layer using shared memory tiling to optimize for spatial locality.

*   **Tiling Strategy:** Each 16x16 thread block loads a 20x20 tile of the input matrix into `__shared__` memory. This 20x20 tile includes the 2-pixel "halo" required for the 5x5 filter radius.
*   **Collaborative Loading:** Threads in the block collaboratively load the halo pixels from global memory to minimize redundant reads.
*   **Dynamic Configuration:** The implementation was enhanced to use `extern __shared__` memory, allowing the `BLOCK_SIZE` and filter `RADIUS` to be tuned via command-line arguments without recompilation.

### Benchmarking (Problem 3)
| Matrix Size | Radius | Runtime |
| :--- | :--- | :--- |
| 2048 x 2048 | 2 (5x5) | 0.001332s |

---

## 5. Problem 4: Convolution + Max-Pooling Pipeline

### Technical Approach
Problem 4 integrates a 5x5 Max-Pooling layer directly into the GPU pipeline following the convolution.

*   **On-Device Processing:** The output of the convolution kernel is stored in a temporary buffer in global memory. The `maxpooling_kernel` is then launched to process this buffer.
*   **Max-Pooling Logic:** Each thread scans a 5x5 window around its pixel and identifies the maximum value. This significantly clarifies features (like diagonal strips) in the resulting image.
*   **Memory Efficiency:** By chaining kernels on the GPU, we avoid copying the intermediate convolution results back to the host.

### Benchmarking (Problem 4)
| Matrix Size | Pipeline Stages | Runtime |
| :--- | :--- | :--- |
| 2048 x 2048 | Conv + MaxPool | 0.002001s |

---

## 6. Conclusion
The transition from a hybrid CPU/GPU model to a fully GPU-resident pipeline yielded significant improvements in data efficiency and compute throughput. The use of **Tree Reduction with 64-bit Atomics** solved the challenge of returning multiple related values (hash + nonce) from a reduction, while **Shared Memory Tiling** ensured high bandwidth for stencil operations. All implementations pass the rigorous GTest unit testing suite and the project autograders with 100% correctness.
