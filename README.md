# Project 3: Mutual Exclusion and Map-Reduce in OpenMP

## Architecture: Self-Contained Implementation
To ensure maximum compatibility with the cluster autograder, each problem variant is implemented as a **fully self-contained** source file. 
*   All logic for file I/O, DNA parsing, and core algorithms is replicated within each individual `.c` file.
*   This structure allows any binary to be compiled independently without external dependencies.

## Build System
A root `Makefile` is provided to manage the entire project:
*   `make all`: Compiles every variant for Problems 2, 3, and 4.
*   `make clean`: Removes all compiled binaries across all directories.

## Coding Standards
*   **Minimalism**: No single-line comments. No redundant explanations for self-evident code.
*   **High Signal**: Use multi-line block comments (`/* ... */`) for logical sections and parallel strategies.
*   **Traceability**: Comments include exact wording and page numbers from `Project_3_Instructions.pdf` for all required algorithm variants.
*   **CLI Structure**:
    *   **Problem 2 & 3**: 5-argument CLI (`input_file`, `output_file`, `time_file`, `num_threads`).
    *   **Problem 4**: 7-argument CLI (`n_points`, `points.csv`, `n_centroids`, `initial_centroids.csv`, `final_centroids.csv`, `time.csv`, `num_threads`).

## Detailed Implementation Notes

### Problem 2 (Average TF)
*   **Algorithm**: Sliding window of size 4 with quaternary indexing (A=0, C=1, G=2, T=3).
*   **Variants**: `critical`, `atomic`, `locks`, and `schedule` (using `schedule(runtime)`).

### Problem 3 (Median TF)
*   **Memory**: Uses a flat 1D array (`num_genes * 256`) for contiguous cache-friendly storage.
*   **Logic**: Standardized `qsort` with even/odd median selection logic.
*   **Variants**: `baseline` (serial median loop) and `mapreduce` (parallel median loop over 256 indices).

### Problem 4 (K-means Clustering)
*   **Map Phase**: Parallel point assignment to nearest centroids using squared Euclidean distance.
*   **Reduce Phase**: Implements **Local Reductions** (private thread-local arrays) to avoid false sharing and minimize synchronization bottlenecks.
*   **Convergence**: Iterates until the total centroid movement distance is <= 1.0.
