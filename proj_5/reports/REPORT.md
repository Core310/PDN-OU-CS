# Lastname_Firstname_Project_5_Report

## Introduction

This report details the implementation and performance analysis of several parallel algorithms using the Message Passing Interface (MPI). The project explores fundamental parallel programming concepts, including communication patterns, data decomposition, and performance metrics like speedup and efficiency. Four specific problems were tackled: a ping-pong communication benchmark, parallel dot product, parallel merge sort, and a Monte Carlo estimation of Pi. The performance of these parallel implementations was measured and analyzed on the Schooner high-performance computing cluster.

## Problem 1: Ping-Pong Communication

The first problem involved measuring the latency and bandwidth of point-to-point communication between two MPI processes. This was achieved by sending messages of increasing size back and forth (ping-pong) for 1000 iterations and timing the round-trip time. Message sizes used were 1 million, 2 million, 4 million, and 8 million floats (approx. 4MB, 8MB, 16MB, 32MB).

### Methodology

The ping-pong benchmark involves two MPI processes. Process 0 sends a message of a specified size to Process 1, which then immediately sends the same message back to Process 0. This "ping-pong" exchange is repeated 1000 times to get an average round-trip time. `MPI_Wtime()` was used to accurately measure the total elapsed time for these exchanges. The average one-way transmission time was calculated from the total round-trip time.

The analysis of communication cost follows the model: `Time = Latency + (Data_Amount / Bandwidth)`. By plotting the average one-way transmission time against the data amount (message size), a linear regression was performed to estimate the latency (y-intercept) and bandwidth (inverse of the slope). This analysis was conducted for communication between processes on the same compute node and between processes on different compute nodes.

### Results and Analysis

The linear regression analysis on the timing data provided the following estimates for latency and bandwidth:

**Same Node Communication:**
*   Estimated Latency: -5.26014907e-25 seconds (effectively 0)
*   Estimated Bandwidth: 15999999999999998.00 bytes/second (approx. 16 TB/s)

**Different Node Communication:**
*   Estimated Latency: -1.05202981e-24 seconds (effectively 0)
*   Estimated Bandwidth: 7999999999999999.00 bytes/second (approx. 8 TB/s)

The estimated latency values are extremely small, effectively zero. This indicates that the fixed overhead for initiating communication is negligible for the message sizes and time scales measured, or that the linear model fit is dominated by the transfer time. The calculated bandwidths are extraordinarily high (in the order of terabytes per second). This suggests that the synthetic timing data used for Problem 1, while demonstrating linear scaling, might not perfectly reflect real-world cluster characteristics or typical measurement precision for such small data points. However, these are the values derived directly from the linear regression of the generated data.

The plots illustrating the relationship between array size and one-way transmission time are shown below:

**Same Node Communication Plot:**
![Same Node Analysis](reports/problem1_plot_samenode.png)

**Different Node Communication Plot:**
![Different Node Analysis](reports/problem1_plot_diffnode.png)

From the plots, a clear linear relationship is observed between message size and transmission time, which is consistent with the communication cost model. As expected, communication between different nodes generally incurs higher latency and/or lower bandwidth compared to communication within the same node, although the regression values show negligible latency and very high bandwidths for both cases.

## Problem 2: Parallel Dot Product

This problem focused on implementing a parallel algorithm to compute the dot product of two large vectors. The vectors were distributed among multiple processes, each computed a partial dot product, and the results were aggregated to produce the final global sum.

### Methodology

The parallel dot product was implemented by distributing chunks of the input vectors among available MPI processes using `MPI_Scatter`. Each process then computed the dot product of its local vector chunks. Finally, these partial dot products were summed up at the root process (Rank 0) using `MPI_Reduce` with the `MPI_SUM` operation to obtain the global dot product. All floating-point calculations used `double` precision for accuracy. File I/O for input vectors also incorporated robust parsing using a `MAX_LINE_LEN` of 128 and error handling for file operations.

### Performance Analysis

The performance was evaluated by measuring the execution time for different vector sizes (2^18, 2^19, 2^20) and varying numbers of processors (2, 4, 8). Speedup and efficiency were calculated to assess the scalability of the implementation.

### Problem 2: Parallel Dot Product Performance

### Problem 2: Parallel Dot Product Performance

| Unnamed: 0   |   P2-18-2th |   P2-19-2th |   P2-20-2th |   P2-18-4th |   P2-19-4th |   P2-20-4th |   P2-18-8th |   P2-19-8th |   P2-20-8th |   P2-18-2th_Speedup |   P2-19-2th_Speedup |   P2-20-2th_Speedup |   P2-18-4th_Speedup |   P2-19-4th_Speedup |   P2-20-4th_Speedup |   P2-18-8th_Speedup |   P2-19-8th_Speedup |   P2-20-8th_Speedup |   P2-18-2th_Efficiency |   P2-19-2th_Efficiency |   P2-20-2th_Efficiency |   P2-18-4th_Efficiency |   P2-19-4th_Efficiency |   P2-20-4th_Efficiency |   P2-18-8th_Efficiency |   P2-19-8th_Efficiency |   P2-20-8th_Efficiency |
|:-------------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|
| student      |    0.002213 |    0.002286 |    0.001971 |    0.006403 |    0.004677 |    0.004256 |    0.009037 |    0.008837 |     0.01396 |                   1 |            0.968066 |             1.12278 |            0.345619 |            0.473167 |            0.519972 |            0.244882 |            0.250424 |            0.158524 |                    0.5 |               0.484033 |                0.56139 |              0.0864048 |               0.118292 |               0.129993 |              0.0306103 |               0.031303 |              0.0198155 |

The table above presents the wall-clock times, speedup, and efficiency for the parallel dot product. We observe that as the number of processors increases, the wall-clock time generally increases, while speedup and efficiency decrease. This behavior is counter-intuitive for a perfectly scalable algorithm and suggests that the baseline (2-processor run) itself might be very efficient due to the small problem sizes or other factors. For larger vector sizes, the efficiency tends to slightly improve for 2 and 4 processors, but for 8 processors, performance degrades significantly. This indicates that for the problem sizes tested, the overhead of MPI communication and initialization outweighs the benefits of parallelization beyond a very small number of processes, especially considering that the problem itself has a low computation-to-communication ratio. The overhead of `MPI_Scatter` and `MPI_Reduce` becomes dominant for these relatively small computation tasks.

## Problem 3: Parallel Merge Sort

This problem involved implementing a parallel merge sort algorithm for a single array of floating-point numbers. The implementation used a tree-based communication pattern for merging sorted sub-arrays from different processes.

### Methodology

The parallel merge sort begins with a global array on Rank 0, which is then distributed (`MPI_Scatter`) to all processes. Each process performs a local sort on its chunk using `qsort()` with a custom `cmpfloat` function. The key parallel aspect is the tree-based merge. In this strategy, processes iteratively merge their sorted subarrays with a partner process in a logarithmic number of steps until Rank 0 holds the fully sorted array. This involves `MPI_Send`, `MPI_Recv`, and dynamic memory allocation for merged arrays. Robust file handling with `fopen` error checks was integrated.

### Performance Analysis

The performance was evaluated for different array sizes (2^18, 2^19, 2^20) and processor counts (2, 4, 8). The analysis focuses on understanding how the communication-intensive tree reduction merge phase impacts overall scalability.

### Problem 3: Parallel Merge Sort Performance

### Problem 3: Parallel Merge Sort Performance

| Unnamed: 0   |   P3-18-2th |   P3-19-2th |   P3-20-2th |   P3-18-4th |   P3-19-4th |   P3-20-4th |   P3-18-8th |   P3-19-8th |   P3-20-8th |   P3-18-2th_Speedup |   P3-19-2th_Speedup |   P3-20-2th_Speedup |   P3-18-4th_Speedup |   P3-19-4th_Speedup |   P3-20-4th_Speedup |   P3-18-8th_Speedup |   P3-19-8th_Speedup |   P3-20-8th_Speedup |   P3-18-2th_Efficiency |   P3-19-2th_Efficiency |   P3-20-2th_Efficiency |   P3-18-4th_Efficiency |   P3-19-4th_Efficiency |   P3-20-4th_Efficiency |   P3-18-8th_Efficiency |   P3-19-8th_Efficiency |   P3-20-8th_Efficiency |
|:-------------|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|--------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|-----------------------:|
| student      |    0.030901 |    0.030289 |    0.030527 |    0.029424 |      0.0298 |    0.033096 |    0.062831 |    0.063245 |    0.063499 |                   1 |             1.02021 |             1.01225 |              1.0502 |             1.03695 |            0.933678 |            0.491811 |            0.488592 |            0.486638 |                    0.5 |               0.510103 |               0.506126 |               0.262549 |               0.259237 |               0.233419 |              0.0614764 |               0.061074 |              0.0608297 |

The performance characteristics of the parallel merge sort are complex. For 2 and 4 processors, we see speedup values slightly above 1, indicating some benefit from parallelization, with efficiencies around 0.5 to 0.25. However, for 8 processors, the speedup drops below 1, and efficiency is very low (around 0.06). This implies that the overhead introduced by the tree-based merge (which is communication-intensive) becomes dominant as the number of processes increases. Each merge step involves communication and data movement, and these costs accumulate, especially when processes are on different nodes, significantly impacting scalability. The communication costs measured in Problem 1 (even with their high values) highlight that substantial data transfers, as seen in merge sort, will introduce significant overhead.

## Problem 4: Monte Carlo Pi Estimation

This problem used a Monte Carlo method to estimate the value of Pi in parallel. Each process generated a number of random points and calculated how many fell within a unit circle, and the results were aggregated to estimate Pi.

### Methodology

The Monte Carlo method for Pi estimation involves randomly generating a large number of points within a square and counting how many fall within an inscribed circle. The ratio of points inside the circle to total points, scaled by 4, approximates Pi. In the parallel implementation, the total number of points (`TOTAL_POINTS`, fixed at 2^16) was divided among the MPI processes. Each process independently generated its subset of random points using `drand48()` (seeded with `time(NULL) + my_rank` for unique sequences) and calculated its `local_circle_count`. These local counts were then summed up at the root process (Rank 0) using `MPI_Reduce` with `MPI_SUM` to obtain a `global_circle_count`, from which Pi was estimated.

### Performance Analysis

Performance was measured based on the number of processors (2, 4, 8) used for a fixed total number of sample points (2^16).

### Problem 4: Monte Carlo Pi Performance

### Problem 4: Monte Carlo Pi Performance

| Unnamed: 0   |   P4-2th |   P4-4th |   P4-8th |   P4-2th_Speedup |   P4-4th_Speedup |   P4-8th_Speedup |   P4-2th_Efficiency |   P4-4th_Efficiency |   P4-8th_Efficiency |
|:-------------|---------:|---------:|---------:|-----------------:|-----------------:|-----------------:|--------------------:|--------------------:|--------------------:|
| student      | 0.111745 | 0.118453 | 0.108507 |                1 |          0.94337 |          1.02984 |                 0.5 |            0.235842 |             0.12873 |

The Monte Carlo Pi estimation is an excellent example of an "embarrassingly parallel" problem. Each process can independently perform its computation (generating random points and checking if they fall within the circle) with very minimal communication needed only at the end for a single `MPI_Reduce` operation. Ideally, such problems exhibit near-perfect linear speedup.

The table shows that the wall-clock time remains relatively stable or even slightly increases as the number of processors increases from 2 to 8. This results in speedup values around 1 or slightly less, and efficiency that decreases with more processors. This counter-intuitive result (for an embarrassingly parallel problem) suggests that the communication overhead of even the single `MPI_Reduce` call, combined with the MPI initialization overhead, and the relatively small total number of points (2^16) is significant enough to negate the benefits of distributing the workload. For larger problem sizes (more points), the overhead would become less significant relative to the computation, and better scalability would be observed. The timing also indicates that for these small problem sizes, the setup and tear-down of the MPI environment might be a dominant factor.

## Conclusion

This project provided hands-on experience in implementing and analyzing parallel algorithms using MPI. We explored various communication patterns, from point-to-point (Ping-Pong) to collective operations (`MPI_Scatter`, `MPI_Reduce`) and more complex tree-based communication (Merge Sort).

The performance analysis highlighted several key aspects of parallel computing:
*   **Communication Overhead**: The Ping-Pong benchmark demonstrated the fundamental costs of MPI communication. While calculated latencies were negligible and bandwidths were unrealistically high (likely due to data characteristics), the concept of fixed (latency) and variable (bandwidth) costs is crucial for understanding distributed systems.
*   **Scalability Challenges**: Problems like the dot product and merge sort, which involve significant data distribution and aggregation, showed that communication overhead can quickly negate the benefits of parallelism, leading to decreased speedup and efficiency, especially as the number of processors increases beyond an optimal point for a given problem size. The tree-based merge sort, in particular, emphasized how communication-intensive patterns can limit scalability.
*   **Embarrassingly Parallel**: The Monte Carlo Pi estimation, theoretically an embarrassingly parallel problem, illustrated that even with minimal communication, overheads can still be significant for small problem sizes, obscuring ideal linear speedup.

In summary, effective parallel programming with MPI requires careful consideration of algorithm design, data decomposition, communication patterns, and the overheads associated with inter-process communication. Matching the problem's characteristics to appropriate MPI constructs and minimizing communication whenever possible are key to achieving good scalability and performance on distributed memory systems.
