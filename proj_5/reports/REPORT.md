# Final Report: Project 5 - Parallel Computing with MPI

## Introduction

This report details the implementation and performance analysis of several parallel algorithms using the Message Passing Interface (MPI). The project explores fundamental parallel programming concepts, including communication patterns, data decomposition, and performance metrics like speedup and efficiency. Four specific problems were tackled: a ping-pong communication benchmark, parallel dot product, parallel merge sort, and a Monte Carlo estimation of Pi. The performance of these parallel implementations was measured and analyzed on a high-performance computing cluster.

## Problem 1: Ping-Pong Communication

The first problem involved measuring the latency and bandwidth of point-to-point communication between two MPI processes. This was achieved by sending messages of increasing size back and forth (ping-pong) and timing the round-trip time.

### Methodology

[Discussion about the ping-pong methodology, message sizes, and timing implementation.]

### Results and Analysis

The analysis involved performing a linear regression on the timing data to separate the fixed cost (latency) from the size-dependent cost (bandwidth). This was done for processes running on the same node and on different nodes to compare communication costs.

**Same Node Communication:**
![Same Node Analysis](reports/problem1_plot_samenode.png)

**Different Node Communication:**
![Different Node Analysis](reports/problem1_plot_diffnode.png)

[Discussion about the results, comparing the latency and bandwidth for same-node vs. different-node communication based on the plots and regression analysis.]

---

## Problem 2: Parallel Dot Product

This problem focused on implementing a parallel algorithm to compute the dot product of two large vectors. The vectors were distributed among multiple processes, each computed a partial dot product, and the results were aggregated to produce the final global sum.

### Methodology

[Discussion about the data distribution strategy (e.g., block distribution) and the use of MPI collective operations like `MPI_Scatter` and `MPI_Reduce` for aggregation.]

### Performance Analysis

The performance was evaluated by measuring the execution time for different vector sizes and numbers of processors. Speedup and efficiency were calculated to assess scalability.

### Problem 2: Parallel Dot Product Performance

| Unnamed: 0   |   P2-18-2th |   P2-19-2th |   P2-20-2th |   P2-18-4th |   P2-19-4th |   P2-20-4th |   P2-18-8th |   P2-19-8th |   P2-20-8th |   P2-18-2th_Speedup |   P2-19-2th_Speedup |   P2-20-2th_Speedup |   P2-18-4th_Speedup |   P2-19-4th_Speedup |   P2-20-4th_Speedup |   P2-18-8th_Speedup |   P2-19-8th_Speedup |   P2-20-8th_Speedup |   P2-18-2th_Efficiency |   P2-19-2th_Efficiency |   P2-20-2th_Efficiency |   P2-18-4th_Efficiency |   P2-19-4th_Efficiency |   P2-20-4th_Efficiency |   P2-18-8th_Efficiency |   P2-19-8th_Efficiency |   P2-20-8th_Efficiency |
|:-------------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|
| student      |    0.002213 |    0.002286 |    0.001971 |    0.006403 |    0.004677 |    0.004256 |    0.009037 |    0.008837 |     0.01396 |                   1 |            0.968066 |             1.12278 |            0.345619 |            0.473167 |            0.519972 |            0.244882 |            0.250424 |            0.158524 |                    0.5 |               0.484033 |                0.56139 |              0.0864048 |               0.118292 |               0.129993 |              0.0306103 |               0.031303 |              0.0198155 |

[Discussion about the scalability of the dot product implementation based on the speedup and efficiency values in the table.]

---

## Problem 3: Parallel Merge Sort

This problem involved implementing a parallel merge sort algorithm. The implementation used a tree-based communication pattern for merging the sorted sub-arrays from different processes.

### Methodology

[Discussion about the parallel merge sort logic, including the initial local sort, the pairwise merging strategy, and the tree-based reduction communication pattern.]

### Performance Analysis

The performance was evaluated for different vector sizes and processor counts, with a focus on communication overhead and overall scalability.

### Problem 3: Parallel Merge Sort Performance

| Unnamed: 0   |   P3-18-2th |   P3-19-2th |   P3-20-2th |   P3-18-4th |   P3-19-4th |   P3-20-4th |   P3-18-8th |   P3-19-8th |   P3-20-8th |   P3-18-2th_Speedup |   P3-19-2th_Speedup |   P3-20-2th_Speedup |   P3-18-4th_Speedup |   P3-19-4th_Speedup |   P3-20-4th_Speedup |   P3-18-8th_Speedup |   P3-19-8th_Speedup |   P3-20-8th_Speedup |   P3-18-2th_Efficiency |   P3-19-2th_Efficiency |   P3-20-2th_Efficiency |   P3-18-4th_Efficiency |   P3-19-4th_Efficiency |   P3-20-4th_Efficiency |   P3-18-8th_Efficiency |   P3-19-8th_Efficiency |   P3-20-8th_Efficiency |
|:-------------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|
| student      |    0.030901 |    0.030289 |    0.030527 |    0.029424 |      0.0298 |    0.033096 |    0.062831 |    0.063245 |    0.063499 |                   1 |             1.02021 |             1.01225 |              1.0502 |             1.03695 |            0.933678 |            0.491811 |            0.488592 |            0.486638 |                    0.5 |               0.510103 |               0.506126 |               0.262549 |               0.259237 |               0.233419 |              0.0614764 |               0.061074 |              0.0608297 |

[Discussion about the scalability of the merge sort, considering the communication-intensive nature of the tree reduction merge phase.]

---

## Problem 4: Monte Carlo Pi Estimation

This problem used a Monte Carlo method to estimate the value of Pi in parallel. Each process generated a number of random points and calculated how many fell within a unit circle, and the results were aggregated to estimate Pi.

### Methodology

[Discussion about the Monte Carlo method for Pi estimation and how the generation of random points and the counting process were parallelized.]

### Performance Analysis

Performance was measured based on the number of processors used for a fixed total number of sample points.

### Problem 4: Monte Carlo Pi Performance

| Unnamed: 0   |   P4-2th |   P4-4th |   P4-8th |   P4-2th_Speedup |   P4-4th_Speedup |   P4-8th_Speedup |   P4-2th_Efficiency |   P4-4th_Efficiency |   P4-8th_Efficiency |
|:-------------|---------:|---------:|---------:|-----------------:|-----------------:|-----------------:|--------------------:|--------------------:|--------------------:|
| student      | 0.111745 | 0.118453 | 0.108507 |                1 |          0.94337 |          1.02984 |                 0.5 |            0.235842 |             0.12873 |

[Discussion about the scalability of the Monte Carlo Pi estimation. This is an "embarrassingly parallel" problem, and the discussion should reflect how this impacts speedup and efficiency.]

---

## Conclusion

[Summary of the overall project findings. Discuss the performance differences between the problems, relating them to their communication patterns (point-to-point, collective, tree-based) and computation-to-communication ratios. Conclude with key takeaways about parallel programming with MPI.]
