# Project: GPU Accelerated Scientific Computing

**Mission:** To gain practical experience with high-performance computing by accelerating a series of data-parallel computational problems using the NVIDIA CUDA platform.

## Core Value Proposition

This project provides hands-on experience in identifying computational bottlenecks in serial code and re-implementing them to leverage the massive parallelism of modern GPUs. The primary value is in learning the principles of heterogeneous computing, GPU architecture, CUDA programming, and performance optimization.

## Project Goals

The project is divided into four distinct computational problems to be solved using CUDA C++.

1.  **Cryptocurrency Mining (Hashing):** Implement a parallel hash generation algorithm on the GPU to replace the serial CPU-based placeholder.
2.  **Cryptocurrency Mining (Reduction):** Implement a parallel reduction algorithm on the GPU to efficiently find the minimum hash value from a large set of candidates.
3.  **Image Convolution:** Implement a 2D convolution filter on the GPU, a fundamental operation in image processing and computer vision.
4.  **Convolution with Max Pooling:** Extend the convolution implementation to include a max pooling layer, another common operation in deep learning.

## Key Constraints & Technologies

-   **Language:** CUDA C++ / C
-   **Platform:** NVIDIA GPU with CUDA Toolkit 10.1 or compatible.
-   **Environment:** The project is designed for a Linux-based High-Performance Computing (HPC) cluster managed by the Slurm Workload Manager.
-   **Build System:** `make` and `nvcc` (NVIDIA CUDA Compiler).
-   **Input/Output:** Data is provided via `.csv` and image files. Results are written to `.csv` files.
-   **Correctness:** Implementations will be verified by comparing their output to that of provided serial C implementations.
-   **Performance:** A key success metric is achieving significant speedup over the serial versions.

## Project Scope

**In Scope:**
-   Implementing the core computational logic for the four problems on the GPU.
-   Managing memory transfers between the CPU (host) and GPU (device).
-   Configuring and launching CUDA kernels with appropriate grid and block dimensions.
-   Ensuring the functional correctness of the GPU implementations.
-   Benchmarking the performance of the GPU code against the serial CPU code.

**Out of Scope:**
-   Developing a graphical user interface (GUI).
-   Building a distributed computing solution.
-   Implementing features beyond the four specified problems.
-   Creating a new testing framework (the existing autograder will be used).
