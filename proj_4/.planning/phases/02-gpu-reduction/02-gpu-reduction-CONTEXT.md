# Phase 2: Problem 2 - GPU Reduction - Context

This document captures the key implementation decisions for Phase 2: GPU Reduction, based on discussions between the user and the agent. These decisions will guide the research and planning for this phase.

## Discussion Summary

### Gray Area 1: Reduction Algorithm Choice
- **Decision:** Prioritize a simpler implementation for the initial pass.
- **Decision:** Utilize atomic operations for managing minimum values.
- **Notes:** A simpler multi-block reduction will involve each block performing a partial reduction, with these partial results then aggregated in a second stage.

### Gray Area 2: Handling Min Nonce alongside Min Hash
- **Decision:** Use two separate `unsigned int` values for `min_hash` and `min_nonce`.
- **Decision:** For tie-breaking when multiple threads find the same `min_hash`, the `min_nonce` that is part of the first atomically updated pair will be chosen.
- **Decision (Atomic Update Mechanism):** Use `atomicCAS` on a packed `unsigned long long` type (combining `min_hash` and `min_nonce`) to ensure both values are updated atomically together.
- **Decision (Initial Values):** Initialize `min_hash` to `MAX` (the program constant 123123123) and `min_nonce` to `UINT_MAX` (from `<limits.h>`).

### Gray Area 3: Kernel Launch Configuration and Data Transfer
- **Decision (Thread Block Size):** Use `BLOCK_SIZE = 1024` threads per block.
- **Decision (Grid Size Determination):** The grid size will be calculated as `ceil((float)trials / (float)BLOCK_SIZE)`.
- **Decision (Data Persistence on Device):** `device_hash_array` and `device_nonce_array` will remain on the device after the hash kernel execution, avoiding Host-to-Device transfers for the reduction kernel input.
- **Decision (Output Transfer Frequency):** Only the final global minimum (`min_hash` and `min_nonce`) will be copied back to the host, after both stages of GPU reduction are completed on the device.

### Gray Area 4: Final Result Aggregation (if multi-block)
- **Decision (Aggregation Method on GPU):** A single thread performing a linear scan on the device will aggregate the partial results into the final global minimum.
- **Decision (Kernel Reusability):** The same reduction kernel will be reused for this final aggregation stage.
- **Decision (Output Location for Final Minimum):** A dedicated temporary single-element device array will store the final `min_hash` and `min_nonce` on the device before host transfer (and will be freed).
- **Decision (Error Handling for Empty Inputs):** A host-side check for `trials == 0` will be performed. If `trials` is 0, kernel launches will be skipped, and `min_hash` will be reported as `MAX` and `min_nonce` as `UINT_MAX`.

## Future Optimizations (from Gray Area 1 discussion)
- **Shared Memory Optimizations:** Future enhancements could include aggressive use of shared memory within blocks, coupled with `__syncthreads()` and warp-level primitives (`__shfl_down_sync`) for faster intra-block reduction.
- **Specialized Libraries:** Libraries like CUDPP or Thrust could be explored for highly optimized, pre-built reduction primitives.

## Code Context
- The serial reduction logic to be replaced is found in `Khor_Arika_Project_4/Problem_1/serial/serial_mining.c` and currently in `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu` within the `// ------ Step 3: Find the nonce with the minimum hash value ------ //` section.
- The `gpu_mining_starter.cu` file, `hash_kernel.cu`, `nonce_kernel.cu`, and `support.h` provide the existing CUDA code structure and patterns.
- The `MAX` constant (123123123) is defined in `gpu_mining_starter.cu` and `serial_mining.c`.
