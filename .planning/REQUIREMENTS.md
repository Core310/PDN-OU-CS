# Requirements for Project 3: Parallel Bioinformatics

## Functional Requirements
### Problem 2: Average Tetranucleotide Frequency (TF)
- Implement `process_tetranucs` to count 4-mer frequencies in DNA sequences.
- Create four versions of the parallel average TF computation:
  - `Exp1_critical`: Using `pragma omp critical`.
  - `Exp1_atomic`: Using `pragma omp atomic`.
  - `Exp1_locks`: Using OpenMP locks (`omp_lock_t`).
  - `Exp2_schedule`: Using different scheduling policies (`static`, `dynamic`, `guided`).
- Measure execution time and compare performance.

### Problem 3: Median Tetranucleotide Frequency
- Store TF results for all genes in a 2D array.
- Implement two versions:
  - `Exp1_baseline`: Simple parallelization.
  - `Exp2_mapreduce`: Using a map-reduce style approach.
- Calculate median for each of the 256 tetranucleotides across all genes.

### Problem 4: K-means Clustering
- Implement serial K-means clustering.
- Parallelize using OpenMP:
  - Assign points to nearest centroids (map phase).
  - Update centroids (reduce phase).
- Use `default(none)` and explicit scope clauses.
- Optimize using mutual exclusion or map-reduce patterns.
- Avoid false sharing and optimize scheduling.

## Technical Requirements
- Language: C (C99 or later).
- Parallelization: OpenMP.
- Build System: Makefile for each problem.
- Environment: OSCER Schooner cluster (Slurm).
- Output: CSV files for results and timing.

## Non-Functional Requirements
- **Readability**: Code must be well-commented and easy to follow.
- **Portability**: Must run on the OSCER cluster environment.
- **Verification**: Must pass the provided autograder scripts.
