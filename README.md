# Project 3: Mutual Exclusion and Map-Reduce in OpenMP

## Architecture: Centralized Setup Module
To ensure consistency and eliminate code duplication, all shared logic is encapsulated in the `setup/` directory.
*   **`setup.c/h`**: Manages CLI parsing, OpenMP configuration, Fasta parsing, and shared algorithms (Sliding Window TF, Median Sorting, CSV Output).
*   **Usage**: All problem variants include `setup.h` and link against `setup.c` via their respective Makefiles.

## Build System
A root `Makefile` is provided to manage the entire project:
*   `make all`: Compiles every variant for Problems 2, 3, and 4.
*   `make clean`: Removes all compiled binaries across all directories.

## Coding Standards
*   **Minimalism**: No single-line comments. No redundant explanations for self-evident code (e.g., variable names or basic I/O).
*   **High Signal**: Use multi-line block comments (`/* ... */`) for logical sections and parallel strategies.
*   **Traceability**: Comments must quote exact wording and page numbers from `Project_3_Instructions.pdf` for all required algorithms.
*   **Structure**: 5-argument CLI for TF problems; strict error handling for malformed data or malloc failures.

## Detailed Coding Plans by Phase

### Phase 1: Problem 2 (Average TF)
**Goal:** Implement sliding window TF calculation with four synchronization variants.
*   **Modular Strategy**: Utilize `handle_setup()` and `process_tetranucs()` from the setup module.
*   **Variants**: `critical`, `atomic`, `locks`, and `schedule` (using `schedule(runtime)`).

### Phase 2: Problem 3 (Median TF)
**Goal:** Calculate the median frequency for each tetranucleotide across all genes.
*   **Memory**: Flat 1D array (`num_genes * 256`) for contiguous cache-friendly storage.
*   **Logic**: Use `find_median()` from setup module (standardized `qsort` + even/odd handling).
*   **Variants**: `baseline` (serial median) and `mapreduce` (parallel median over 256 indices).

### Phase 3: Problem 4 (K-means Clustering)
**Goal:** Parallelize 2D K-means clustering using local reductions to avoid false sharing.
*   **Architecture**: Self-contained implementation within `kmeans_clustering.c` (no dependency on the shared `setup` module).
*   **Parallel Strategy:**
    /* 
     * Map Phase: Parallelize point assignment to nearest centroids using squared distance.
     * Reduce Phase: Use thread-local arrays for partial sums and counts 
     * to avoid false sharing and minimize critical section overhead.
     */
*   **Convergence:** Loop continues until total centroid movement distance <= 1.0 (Req: Page 11).
*   **CLI & Output:** 
    - 7 arguments: n_points, points.csv, n_centroids, centroids.csv, output.csv, time.csv, num_threads (Req: Page 12).
    - Precision: %.6f for centroid coordinates.
    - Raw numeric seconds in time.csv.

### Phase 4: Build System Consolidation
**Goal:** Ensure consistent and clean build environment.
*   Standardize all Makefiles to use `-O3`, `-fopenmp`, and `-lm`.

### Phase 5: Report Generation
**Goal:** Create a Markdown report template following the Project 2 format.
