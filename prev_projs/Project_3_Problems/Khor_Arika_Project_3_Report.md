# Project 3 Report: Mutual Exclusion and Map-Reduce in OpenMP
**Author:** Arika Khor

## Problem 2: Average Tetranucleotide Frequency (TF)

### Algorithm Description
The goal of this problem is to calculate the average frequencies of all 256 possible 4-character DNA sequences (tetranucleotides) across the human genome. We implemented a sliding window of size 4 that moves across nucleotide sequences. Each window is converted into a 0-255 index using a quaternary numeral system (A=0, C=1, G=2, T=3).

The primary technical challenge is managing the race condition when multiple threads update the global frequency array. We implemented and compared three mutual exclusion techniques:
1.  **Critical** Section: Uses #pragma omp critical to serialize updates to the global array.
2.  **Atomic** Updates: Uses #pragma omp atomic for fine-grained, thread-safe updates to individual array elements.
3.  **Locks:** Uses an array of 256 omp_lock_t locks to allow concurrent updates to different tetranucleotide indices.
4.  **Schedule:** Uses schedule(runtime) to experiment with static, dynamic, and guided scheduling for better load balancing.

### Performance Results (Schooner Cluster)

#### Runtime (seconds) - 50 Genes
| Threads | Critical | Atomic | Locks | Schedule |
| :--- | :--- | :--- | :--- | :--- |
| **p = 8** | 0.000819 | 0.000760 | 0.001009 | 0.000688 |

#### Runtime (seconds) - Reduced Dataset
| Threads | Critical | Atomic | Locks | Schedule |
| :--- | :--- | :--- | :--- | :--- |
| **p = 8** | 0.200831 | 0.208455 | 0.374331 | 0.209353 |

---

## Problem 3: Median Tetranucleotide Frequency

### Algorithm Description
This problem extends the TF calculation to find the median frequency for each of the 256 tetranucleotides. Unlike the average, finding the median requires storing the frequency counts for every gene in a large 2D matrix. We used a flat 1D array allocation to ensure contiguous memory and optimal cache performance.

We compared two parallelization strategies:
1.  **Baseline:** Parallelizes the initial frequency calculation (Map phase) while performing the median sorting and selection serially.
2.  **Map-Reduce:** Parallelizes both phases. In the "Reduce" phase, the 256 tetranucleotide indices are distributed among threads, allowing multiple sort operations to occur concurrently.

### Performance Results (Schooner Cluster)

#### Runtime (seconds) - 50 Genes
| Threads | Baseline | Map-Reduce |
| :--- | :--- | :--- |
| **p = 1** | 0.002997 | 0.003036 |
| **p = 2** | 0.001923 | 0.001733 |
| **p = 4** | 0.001417 | 0.001077 |
| **p = 8** | 0.001228 | 0.000776 |

#### Runtime (seconds) - Reduced Dataset
| Threads | Baseline | Map-Reduce |
| :--- | :--- | :--- |
| **p = 1** | 2.143732 | 2.181967 |
| **p = 2** | 1.593180 | 1.259576 |
| **p = 4** | 1.243306 | 0.662861 |
| **p = 8** | 1.004089 | 0.350897 |

#### Speedup (Reduced Dataset)
| Threads | Baseline | Map-Reduce |
| :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 |
| **p = 2** | 1.345 | 1.732 |
| **p = 4** | 1.724 | 3.292 |
| **p = 8** | 2.135 | 6.218 |

---

## Problem 4: K-means Clustering

### Algorithm Description
K-means clustering partitions N 2D points into K=16 clusters. The algorithm is iterative, continuing until the total movement of all centroids is <= 1.0. Each iteration consists of two main parallel phases:
1.  **Assignment** (Map Phase): Each thread calculates the squared Euclidean distance from its points to all 16 centroids and assigns each point to the nearest one.
2.  **Update** (Reduce Phase): To avoid False Sharing and minimize synchronization overhead, we implemented Local Reductions. Each thread maintains its own private partial sum and count arrays for the centroids.

### Performance Results (Schooner Cluster)

#### Runtime (seconds)
| Threads | 1M Points | 4M Points | 16M Points |
| :--- | :--- | :--- | :--- |
| **p = 1** | 0.051437 | 0.207072 | 0.830307 |
| **p = 4** | 0.013215 | 0.052801 | 0.211622 |
| **p = 16** | 0.003865 | 0.014278 | 0.056446 |

#### Speedup (16M Points)
| Threads | Speedup |
| :--- | :--- |
| **p = 1** | 1.000 |
| **p = 4** | 3.924 |
| **p = 16** | 14.710 |

---

## Scalability Analysis

### Problem 2: Mutual Exclusion Comparison
The results for Problem 2 highlight the overhead differences between mutual exclusion techniques. **Critical** and **Atomic** directives showed similar performance, with Critical slightly outperforming Atomic on this specific workload. However, the **Locks** variant was significantly slower (approx. 86% overhead compared to Critical). This is likely due to the overhead of managing 256 individual omp_lock_t objects, which outweighs the benefits of fine-grained locking for this relatively fast tetranucleotide counting task.

### Problem 3: Map-Reduce Efficiency
Problem 3 demonstrates a stark contrast between simple parallelization and the Map-Reduce pattern. The **Baseline** version achieved a maximum speedup of only 2.14x on 8 threads, as the serial sorting of 256 indices became a significant bottleneck. In contrast, the **Map-Reduce** version achieved 6.22x speedup, showing much better scalability by parallelizing the sorting phase across the 256 tetranucleotide indices.

### Problem 4: Local Reductions and False Sharing
K-means clustering exhibited the best scalability, reaching 14.71x speedup on 16 threads for the 16M points dataset. This near-linear scaling is attributed to the use of **Local Reductions**. By giving each thread private copies of centroid sums and counts, we completely avoided False Sharing and minimized the use of synchronization primitives to a single critical section per thread at the end of the iteration.
