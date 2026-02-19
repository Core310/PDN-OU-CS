# Project 3 Report: Mutual Exclusion and Map-Reduce in OpenMP
**Author:** Arika Khor

## Problem 2: Average Tetranucleotide Frequency (TF)

### Algorithm Description
The goal of this problem is to calculate the average frequencies of all 256 possible 4-character DNA sequences (tetranucleotides) across the human genome. We implemented a **sliding window of size 4** that moves across nucleotide sequences. Each window is converted into a 0-255 index using a quaternary numeral system (A=0, C=1, G=2, T=3) with the formula: `idx = Window[0]*64 + Window[1]*16 + Window[2]*4 + Window[3]`.

The primary technical challenge is managing the race condition when multiple threads update the global frequency array. We implemented and compared three mutual exclusion techniques:
1.  **Critical Section:** Uses `#pragma omp critical` to serialize updates to the global array.
2.  **Atomic Updates:** Uses `#pragma omp atomic` for fine-grained, thread-safe updates to individual array elements.
3.  **Locks:** Uses an array of 256 `omp_lock_t` locks to allow concurrent updates to different tetranucleotide indices.

Additionally, we implemented a version using `schedule(runtime)` to experiment with static, dynamic, and guided scheduling for better load balancing across varying gene lengths.

### Performance Results (Schooner Cluster)

#### Runtime (seconds)
| Threads | Critical | Atomic | Locks |
| :--- | :--- | :--- | :--- |
| **p = 1** | | | |
| **p = 2** | | | |
| **p = 4** | | | |
| **p = 8** | | | |

#### Speedup ($S = T_1 / T_p$)
| Threads | Critical | Atomic | Locks |
| :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 |
| **p = 2** | | | |
| **p = 4** | | | |
| **p = 8** | | | |

---

## Problem 3: Median Tetranucleotide Frequency

### Algorithm Description
This problem extends the TF calculation to find the median frequency for each of the 256 tetranucleotides. Unlike the average, finding the median requires storing the frequency counts for every gene in a large 2D matrix (`num_genes` x 256). We used a **flat 1D array** allocation to ensure contiguous memory and optimal cache performance.

We compared two parallelization strategies:
1.  **Baseline:** Parallelizes the initial frequency calculation (Map phase) while performing the median sorting and selection serially.
2.  **Map-Reduce:** Parallelizes both phases. In the "Reduce" phase, the 256 tetranucleotide indices are distributed among threads, allowing multiple sort operations (`qsort`) to occur concurrently.

### Performance Results (Schooner Cluster)

#### Runtime (seconds)
| Threads | Baseline | Map-Reduce |
| :--- | :--- | :--- |
| **p = 1** | | |
| **p = 2** | | |
| **p = 4** | | |
| **p = 8** | | |

#### Speedup ($S = T_1 / T_p$)
| Threads | Baseline | Map-Reduce |
| :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 |
| **p = 2** | | |
| **p = 4** | | |
| **p = 8** | | |

---

## Problem 4: K-means Clustering

### Algorithm Description
K-means clustering partitions $N$ 2D points into $K=16$ clusters. The algorithm is iterative, continuing until the total movement of all centroids is $\le 1.0$. Each iteration consists of two main parallel phases:
1.  **Assignment (Map Phase):** Each thread calculates the squared Euclidean distance from its points to all 16 centroids and assigns each point to the nearest one.
2.  **Update (Reduce Phase):** To avoid **False Sharing** and minimize synchronization overhead, we implemented **Local Reductions**. Each thread maintains its own private partial sum and count arrays for the centroids. These local results are merged into the global centroids using a single `critical` section per thread only after all local points are processed.

### Performance Results (Schooner Cluster)

#### Runtime (seconds)
| Threads | 1M Points | 4M Points | 16M Points |
| :--- | :--- | :--- | :--- |
| **p = 1** | | | |
| **p = 2** | | | |
| **p = 4** | | | |
| **p = 8** | | | |

#### Speedup ($S = T_1 / T_p$)
| Threads | 1M Points | 4M Points | 16M Points |
| :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 |
| **p = 2** | | | |
| **p = 4** | | | |
| **p = 8** | | | |

---

## Scalability Analysis
[To be completed after running benchmarks. Discuss the overhead of different mutual exclusion types in Problem 2, the efficiency gains from the Map-Reduce pattern in Problem 3, and the impact of local reductions on avoiding false sharing in Problem 4.]
