# Phase 4: Problem 4 - Convolution with Max-Pooling - Context

This document captures the key implementation decisions for Phase 4: Convolution with Max-Pooling, based on discussions between the user and the agent. These decisions will guide the research and planning for this phase.

## Discussion Summary

### Gray Area 1: Window Size and Stride
- **Decision:** Use a **5x5 window** with a **stride of 1**.
- **Rationale:** This strictly replicates the behavior of the serial implementation (`convolution_maxpooling_serial.c`), ensuring the output dimensions match and the autograder passes.

### Gray Area 2: Kernel Strategy (Fusion vs. Modular)
- **Decision:** Implement a **fused kernel**.
- **Rationale:** A single kernel will perform the 2D convolution and immediately apply the max-pooling operation. This maximizes performance by avoiding the overhead of writing intermediate convolution results to global memory and launching a second kernel.

### Gray Area 3: Shared Memory for Pooling
- **Decision:** Data will be managed in **shared memory** within the fused kernel.
- **Notes:** The tiling strategy from Phase 3 (collaborative loading of input tiles + halos) will be reused. The max-pooling step will operate on the convolution results stored in shared memory/registers.

### Gray Area 4: Robust Maximum Initialization
- **Decision:** Initialize the `max` variable to **`INT_MIN`** (from `<limits.h>`).
- **Rationale:** Ensures correctness if the convolution produced only negative values in a given window, addressing a potential edge-case bug in the serial code's use of `0`.

## Code Context
- **Reference Logic:** `Khor_Arika_Project_4/Problem_4/serial/convolution_maxpooling_serial.c`.
- **Base Code:** The host and kernel implementation from Phase 3 (`Khor_Arika_Project_4/Problem_3/`) will serve as the starting point.
- **Target Location:** New implementation in `Khor_Arika_Project_4/Problem_4/`.
- **Pre-padding:** The 2-pixel host-side pre-padding strategy from Phase 3 remains essential to simplify the fused kernel logic.
