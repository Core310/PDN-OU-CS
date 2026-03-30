<div style="background-color: #000000; color: #808080; padding: 40px; font-family: 'Courier New', Courier, monospace; line-height: 1.6;">

<div style="text-align: center;">
    <h1 style="color: #ffffff;">Project 4 Report: Tree Reduction and Stencil Computation in GPU</h1>
    <p style="font-size: 1.2em;">Author: Arika Khor</p>
    <p>Semester: SPRING 2026 | Course: CS5473</p>
</div>

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">1. Introduction</h2>
This project implements and optimizes three fundamental parallel computing patterns using the NVIDIA CUDA platform: **Embarrassingly Parallel** (Hash Generation), **Tree Reduction** (Minimum Search), and **Stencil Computation** (2D Convolution and Max-Pooling). 

The goal was to transform a serial cryptocurrency mining and image processing workflow into a high-performance GPU-resident pipeline, minimizing Host-to-Device (H2D) and Device-to-Host (D2H) bottlenecks.

<h3 style="color: #cccccc;">Project Layout</h3>
The submission is structured to maintain strict modularity and facilitate comprehensive verification:

<ul>
    <li><strong><code>common/</code></strong>: Shared infrastructure containing the centralized <code>support.h</code> and <code>support.cu</code> for timing and the unified <code>gpuErrchk</code> error-handling macro.</li>
    <li><strong><code>Problem_1/</code></strong>: Offloads hash generation to the GPU while retaining CPU-based reduction.</li>
    <li><strong><code>Problem_2/</code></strong>: Fully optimized mining utilizing an on-device 64-bit atomic tree reduction.</li>
    <li><strong><code>Problem_3/</code></strong>: 2D tiled convolution using dynamic shared memory and runtime configuration.</li>
    <li><strong><code>Problem_4/</code></strong>: Integrated GPU pipeline combining convolution and 5x5 max-pooling.</li>
    <li><strong><code>serial/</code></strong>: Consolidated reference implementations for cross-validation.</li>
    <li><strong><code>tests/</code></strong>: GTest-based unit testing suite for kernel-level verification.</li>
</ul>

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">2. Problem 1 & 2: PDNcoin Mining and Reduction</h2>

<h3 style="color: #cccccc;">Algorithm Description</h3>
The PDNcoin mining process involves three steps: Nonce Generation, Hash Calculation, and Global Minimum Search. 

In **Problem 1**, we offloaded the hash calculation to the GPU. Each thread calculates a hash for a unique nonce using modular arithmetic over 20,000 transactions. However, the bottleneck remained in Step 3, where the entire hash array was copied back to the CPU for a serial minimum search.

In **Problem 2**, we implemented a **Fully Parallel Tree Reduction**. To handle the requirement of returning both the minimum hash *and* its associated nonce, we utilized a packed 64-bit approach.

<h4 style="color: #cccccc;">64-bit Atomic Packing</h4>
The hash (32-bit) and nonce (32-bit) are packed into a single <code>unsigned long long</code>. By placing the hash in the upper bits, a simple <code>atomicCAS</code> (Compare-And-Swap) or tree-based comparison naturally prioritizes the minimum hash value while keeping the nonce linked.

<h4 style="color: #cccccc;">Code Snippet: Optimized Reduction Kernel</h4>

```cpp
__global__ void reduction_kernel(unsigned int *d_hashes, unsigned int *d_nonces, int num_elements, unsigned long long *d_min_result) {
    extern __shared__ unsigned int s_data[];
    unsigned int *s_hashes = s_data;
    unsigned int *s_nonces = &s_data[blockDim.x];

    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    // Load data into shared memory with tie-breaking initialization
    if(i < num_elements) {
        s_hashes[tid] = d_hashes[i];
        s_nonces[tid] = d_nonces[i];
    } else {
        s_hashes[tid] = MAX;
        s_nonces[tid] = 0xFFFFFFFFU;
    }
    __syncthreads();

    // In-block tree reduction
    for (unsigned int s=blockDim.x/2; s>0; s>>=1) {
        if (tid < s) {
            if (s_hashes[tid] > s_hashes[tid+s]) {
                s_hashes[tid] = s_hashes[tid+s];
                s_nonces[tid] = s_nonces[tid+s];
            } else if (s_hashes[tid] == s_hashes[tid+s]) {
                if (s_nonces[tid] > s_nonces[tid+s]) s_nonces[tid] = s_nonces[tid+s];
            }
        }
        __syncthreads();
    }

    // Update global result using atomicCAS
    if (tid == 0) {
        unsigned long long local_min = ((unsigned long long)s_hashes[0] << 32) | (unsigned long long)s_nonces[0];
        unsigned long long assumed;
        unsigned long long old = *d_min_result;
        do {
            assumed = old;
            if (local_min < assumed) old = atomicCAS(d_min_result, assumed, local_min);
            else break;
        } while (assumed != old);
    }
}
```

<h3 style="color: #cccccc;">Performance Results (Schooner Cluster)</h3>

<table style="width: 100%; border-collapse: collapse; color: #808080;">
    <thead>
        <tr style="border-bottom: 1px solid #333;">
            <th style="text-align: left; padding: 8px;">Implementation</th>
            <th style="text-align: left; padding: 8px;">5M Trials</th>
            <th style="text-align: left; padding: 8px;">10M Trials</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="padding: 8px;">Problem 1 (CPU Reduction)</td>
            <td style="padding: 8px;">0.678518s</td>
            <td style="padding: 8px;">1.131965s</td>
        </tr>
        <tr>
            <td style="padding: 8px;">Problem 2 (GPU Reduction)</td>
            <td style="padding: 8px;">0.632880s</td>
            <td style="padding: 8px;">1.087014s</td>
        </tr>
    </tbody>
</table>

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">3. Problem 3 & 4: Tiled Convolution and Max-Pooling</h2>

<h3 style="color: #cccccc;">Algorithm Description</h3>
The convolution layer implements a 2D stencil operation with a 5x5 filter and zero padding. To optimize memory access, we implemented **Shared Memory Tiling**.

<h4 style="color: #cccccc;">Implementation Details</h4>
<ul>
    <li><strong>Halo Handling:</strong> Each thread block loads a tile plus a surrounding "halo" of size <code>RADIUS</code>. Collaboratively loading this halo into shared memory reduces global memory traffic by a factor proportional to the block size.</li>
    <li><strong>Dynamic Shared Memory:</strong> To support configurable <code>BLOCK_SIZE</code> and <code>RADIUS</code> at runtime, we refactored the kernels to use <code>extern __shared__</code> and manual pointer partitioning.</li>
    <li><strong>Chained Pipeline:</strong> In Problem 4, the output of the convolution is kept on the device and immediately processed by the max-pooling kernel, avoiding redundant D2H/H2D transfers.</li>
</ul>

<h4 style="color: #cccccc;">Code Snippet: Tiled Convolution with Dynamic Halo</h4>

```cpp
__global__ void convolution_kernel(int* paddedInput, int* filter, int* output, int n_row, int n_col, int radius) {
    extern __shared__ int s_data[];
    int filter_dim = 2 * radius + 1;
    int* filter_s = s_data;
    int* tile_s = &s_data[filter_dim * filter_dim];

    int tile_dim = blockDim.x + 2 * radius;
    // Collaborative loading of tile + halo
    for (int i = threadIdx.y; i < tile_dim; i += blockDim.y) {
        for (int j = threadIdx.x; j < tile_dim; j += blockDim.x) {
            int global_row = blockIdx.y * blockDim.y + i;
            int global_col = blockIdx.x * blockDim.x + j;
            if (global_row < n_row + 2 * radius && global_col < n_col + 2 * radius)
                tile_s[i * tile_dim + j] = paddedInput[global_row * (n_col + 2 * radius) + global_col];
            else tile_s[i * tile_dim + j] = 0;
        }
    }
    __syncthreads();
    // ... stencil calculation ...
}
```

<h3 style="color: #cccccc;">Performance Results (2048 x 2048 Matrix)</h3>

<table style="width: 100%; border-collapse: collapse; color: #808080;">
    <thead>
        <tr style="border-bottom: 1px solid #333;">
            <th style="text-align: left; padding: 8px;">Metric</th>
            <th style="text-align: left; padding: 8px;">Problem 3 (Conv)</th>
            <th style="text-align: left; padding: 8px;">Problem 4 (Conv+Pool)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="padding: 8px;">Runtime (seconds)</td>
            <td style="padding: 8px;">0.001332s</td>
            <td style="padding: 8px;">0.002001s</td>
        </tr>
    </tbody>
</table>

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">4. Scalability and Robustness Analysis</h2>

<h3 style="color: #cccccc;">Reduction Bottlenecks</h3>
Problem 2 demonstrated that while GPU reduction is theoretically orders of magnitude faster than CPU reduction, for 10M trials, the performance gain is partially masked by fixed overheads (File I/O and kernel startup). However, the massive reduction in D2H transfer (from 40MB to 8 bytes) ensures that the system scales efficiently as trial counts increase into the billions.

<h3 style="color: #cccccc;">Spatial Locality in Stencils</h3>
The convolution results confirm the efficiency of shared memory tiling. By collaborative loading of input tiles, we achieved sub-millisecond execution times for a 4-million element matrix. The implementation's robustness was verified through a new **GTest suite**, which confirmed correctness across non-multiple grid sizes and varying radii.

<h3 style="color: #cccccc;">Error Handling Strategy</h3>
To ensure reliability, we integrated a centralized <code>gpuErrchk</code> macro. This enforces a "Fail Fast" policy, where any CUDA API failure (e.g., out-of-memory or invalid launch) provides an immediate trace of the file and line number.

```cpp
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
```

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">5. AI Usage and Workflow</h2>

<h3 style="color: #cccccc;">Methodology</h3>
The project was developed using a semi-autonomous workflow centered around the **Gemini CLI** and the **GSD (getshitdone)** planning framework.

<ul>
    <li><strong>Research:</strong> Used Gemini CLI to analyze the project PDF and generate initial architecture mappings.</li>
    <li><strong>Planning:</strong> GSD was used to decompose the four problems into 5 distinct execution phases with automated verification checkpoints.</li>
    <li><strong>Execution:</strong> Kernels were written manually, while the Gemini CLI was used to perform "surgical" refactoring, such as migrating static shared memory to dynamic <code>extern</code> arrays across multiple files.</li>
    <li><strong>Verification:</strong> AI agents assisted in generating the GTest unit tests and fixing <code>pandas</code> API regressions in the provided autograder scripts.</li>
</ul>

<hr style="border: 0.5px solid #333;">

<h2 style="color: #ffffff;">6. Phase Progression</h2>

<dl>
    <dt style="color: #cccccc; font-weight: bold;">Phase 1: Foundational Refactoring</dt>
    <dd>Centralized <code>support</code> code and integrated the unified <code>gpuErrchk</code> macro. Fixed critical string literal regressions in starter code.</dd>

    <dt style="color: #cccccc; font-weight: bold;">Phase 2: Algorithm Optimization</dt>
    <dd>Implemented 64-bit atomic GPU reduction. Eliminated host-side bottlenecks in Problem 1 and 2.</dd>

    <dt style="color: #cccccc; font-weight: bold;">Phase 3: Unit Testing Integration</dt>
    <dd>Integrated Google Test. Verified all kernels against host-side serial references (100% pass).</dd>

    <dt style="color: #cccccc; font-weight: bold;">Phase 4: Configuration and Usability</dt>
    <dd>Refactored all kernels for dynamic shared memory. Enabled command-line arguments for <code>BLOCK_SIZE</code> and <code>RADIUS</code>.</dd>

    <dt style="color: #cccccc; font-weight: bold;">Phase 5: Finalization</dt>
    <dd>Consolidated serial reference code, authored delivery documentation, and performed final project validation.</dd>
</dl>

</div>
