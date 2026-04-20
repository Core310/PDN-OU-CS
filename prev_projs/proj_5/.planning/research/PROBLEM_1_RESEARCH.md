# Research: Problem 1 - Ping-Pong (Phase 1)

## Requirements
- **Goal:** Estimate MPI communication time by bouncing an array between two processes 1000 times.
- **Array Sizes ($n$):** 1,000,000; 2,000,000; 4,000,000; 8,000,000 (integers).
- **Execution Scenarios:**
    1. Same Node: Both processes on the same compute node (`ntasks-per-node=2`).
    2. Different Nodes: Processes on different compute nodes (`ntasks-per-node=1`, `nodes=2`).
- **Timing:** Use `MPI_Wtime()` to record total time for 1000 round trips.
- **Output File:** `time_prob1_MPI.csv` (contains the total time).
- **CLI Arguments:** `pingpong_MPI n_items time_prob1_MPI.csv`.
- **Analysis:**
    - Calculate average one-way trip time.
    - Linear regression: $T_{avg} = \text{latency} + \frac{\text{Data Amount}}{\text{Bandwidth}}$.
    - Two plots (one for each scenario).

## Implementation Details
- **Rank 0:**
    - Initialize array with incremental values.
    - Start timer.
    - Loop 1000 times: `MPI_Send` to Rank 1, `MPI_Recv` from Rank 1.
    - Stop timer.
    - Write total time to CSV.
- **Rank 1:**
    - Loop 1000 times: `MPI_Recv` from Rank 0, `MPI_Send` back to Rank 0.
- **Data Types:** `int` array. Size in bytes = $n \times \text{sizeof(int)}$.

## References
- `Project_5_Instructions.pdf`, Page 4.
- `pingpong_MPI.c` (existing template).
