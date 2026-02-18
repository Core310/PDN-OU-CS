# Project 3: Mutual Exclusion and Map-Reduce in OpenMP

This project involves parallelizing bioinformatics algorithms using OpenMP, focusing on mutual exclusion, load balancing, and map-reduce patterns.

## Detailed Coding Plans by Phase

### Phase 1: Problem 2 (Average TF)
**Goal:** Implement sliding window tetranucleotide frequency (TF) calculation with four synchronization/scheduling variants.
*   **Core Logic (`process_tetranucs`):** 
    *   Iterate through DNA sequence with a sliding window of 4.
    *   Map nucleotides {A, C, G, T} to values {0, 1, 2, 3}.
    *   Calculate 0-255 index: `(val[0] << 6) + (val[1] << 4) + (val[2] << 2) + val[3]` (or equivalent multiplication).
*   **Variants (Each in its own file as per instructions):**
    *   **`Exp1_critical`**: Add gene-local results to the global `TF` array within a `#pragma omp critical` block.
    *   **`Exp1_atomic`**: Iterate through the 256 local TF counts and update the global array using `#pragma omp atomic`.
    *   **`Exp1_locks`**: Initialize 256 `omp_lock_t` locks. Each thread locks `locks[idx]` before updating `TF[idx]`.
    *   **`Exp2_schedule`**: Use the `critical` method for aggregation, but set the parallel loop to `schedule(runtime)` to allow external configuration. Accept `num_threads` as a 4th command-line argument.
*   **Build:** Makefile targets for each variant with `-O3` and `-fopenmp`.

### Phase 2: Problem 3 (Median TF)
**Goal:** Calculate the median frequency for each tetranucleotide across all genes.
*   **Data Structure:** A 2D array `int** gene_TF_counts` of size `num_genes x 256`.
*   **Variants:**
    *   **`Exp1_baseline`**: 
        *   Parallelize the first loop (filling the 2D array).
        *   Keep the second loop (calculating medians for 256 indices) serial.
    *   **`Exp2_mapreduce`**: 
        *   Parallelize both loops. The second loop will use `#pragma omp parallel for` where each thread handles a subset of the 256 tetranucleotide indices.
*   **Median Logic:** Use `qsort` on a temporary array of frequencies for each index. Handle even/odd gene counts correctly.

### Phase 3: Problem 4 (K-means Clustering)
**Goal:** Parallelize 2D K-means clustering with optimization to avoid false sharing.
*   **Iteration Loop:** Continue until total centroid movement $\le 1.0$.
*   **Map Phase (Assignment):** 
    *   Parallelize the loop over points. Each thread assigns its points to the nearest centroid.
*   **Reduce Phase (Update):** 
    *   Each thread maintains **local partial sums** and **local counts** for all $K$ centroids to avoid frequent synchronization and false sharing.
    *   After the local loop, use `#pragma omp critical` to aggregate local sums into global centroids.
*   **Optimization:** Use `default(none)` and explicit scoping for all variables.

### Phase 4: Build System Consolidation
**Goal:** Ensure consistent and clean build environment.
*   Standardize all Makefiles to use `-O3`, `-fopenmp`, and `-lm`.
*   Ensure targets match the submission requirements exactly.

### Phase 5: Report Generation
**Goal:** Create a Markdown report template ready for data.
*   Format: Based on Project 2 report.
*   Contents: Algorithm descriptions, parallel strategies, and empty tables for Runtime, Speedup, and Efficiency.
