# Phase 3: Problem 3 - Convolution with CUDA - Context

This document captures the key implementation decisions for Phase 3: Convolution with CUDA, based on discussions between the user and the agent. These decisions will guide the research and planning for this phase.

## Discussion Summary

### Gray Area 1: 2D Data Mapping to CUDA Grid
- **Decision:** A **2D grid of 2D thread blocks** will be used. This provides a natural mapping where each thread is responsible for computing a single output pixel.

### Gray Area 2: Filter (Kernel) Memory Strategy
- **Decision:** The 5x5 convolution filter will be loaded into **shared memory** by each thread block. This ensures fast, cached access for all threads within the block.

### Gray Area 3: Boundary Handling for Edge Pixels
- **Decision:** Boundary handling will be managed by using a **pre-padded input image**.
- **Notes:** The padding will be calculated and applied on the host (CPU) before the input matrix is transferred to the device (GPU). This simplifies the kernel logic by removing the need for conditional boundary checks.

### Gray Area 4: Input Data Tiling Strategy
- **Decision:** A **tiled memory approach** will be implemented.
- **Notes:** Each thread block will collaboratively load a tile of the input image (including the necessary "halo" or "ghost" cells required for the convolution) into shared memory. This strategy is chosen to maximize data reuse and minimize global memory access, which is critical for performance.

## Code Context
- The serial convolution logic to be parallelized is found in `Khor_Arika_Project_4/Problem_3/serial/convolution_serial.c`.
- The host application will need to be created for this problem, likely in a new `Khor_Arika_Project_4/Problem_3/` directory. It will be responsible for reading the input matrix, performing the pre-padding, managing memory transfers, launching the kernel, and saving the output.
- Reusable patterns for CUDA error checking (`err_check`), kernel launch syntax, and `Makefile` structure can be adapted from the work done in Phase 1 and 2.
