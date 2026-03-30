# Architecture

**Analysis Date:** 2025-05-15

## Pattern Overview

**Overall:** MPI-based Distributed Computing (SPMD pattern)

**Key Characteristics:**
- Single Program Multiple Data (SPMD): The same executable is run across multiple MPI ranks.
- Message Passing: Explicit data transfer between ranks using `MPI_Send`, `MPI_Recv`, `MPI_Scatter`, `MPI_Gather`, etc.
- Task Parallelism: Independent processing of vector segments, array sorting, and Pi calculations.

## Layers

**Task Management (SLURM):**
- Purpose: Scheduling jobs on the cluster, allocating resources (nodes/tasks).
- Location: `Problem_*/[name].sbatch`
- Contains: Resource requests (`--ntasks`, `--partition`), module loading, and `mpirun` execution commands.
- Depends on: Cluster infrastructure (Slurm).
- Used by: Researchers/Developers running the problems.

**Parallel Implementation (MPI):**
- Purpose: Distributed logic for solving the individual problems.
- Location: `Problem_*/[name]_MPI.c`
- Contains: MPI initialization, rank logic, communication, and synchronization.
- Depends on: OpenMPI library.
- Used by: Executable binary built via Makefile.

**Build Automation:**
- Purpose: Compiling source code with the necessary MPI compiler (`mpicc`).
- Location: `Problem_*/Makefile`
- Contains: Build targets (`all`, `clean`) and compilation flags (`-g`, `-Wall`).

## Data Flow

**General MPI Parallel Pattern:**

1. **Initialization:** `MPI_Init` sets up the communicator.
2. **Distribution:** Rank 0 (usually) reads input from files (`.csv`) and distributes it to other ranks (Scatter/Bcast).
3. **Local Computation:** Each rank performs its share of the workload (e.g., local dot product, local merge sort).
4. **Reduction/Collection:** Ranks send their results back to Rank 0 (Gather/Reduce) or synchronize via barriers.
5. **Output:** Rank 0 writes the aggregated results and timing data to output files.

**State Management:**
- Each MPI process maintains its own memory space. Coordination is done solely through message passing.

## Entry Points

**Ping-Pong MPI:**
- Location: `Problem_1/pingpong_MPI.c`
- Triggers: SLURM job `pingpong_samenode.sbatch` or `pingpong_diffnode.sbatch`.
- Responsibilities: Measure message passing latency between ranks.

**Merge Sort MPI:**
- Location: `Problem_3/merge_sort_MPI.c`
- Triggers: SLURM job `merge_sort_samenode.sbatch` or `merge_sort_diffnode.sbatch`.
- Responsibilities: Distribute array, sort locally, and merge results.

## Error Handling

**Strategy:** Command-line argument validation and file open checks.

**Patterns:**
- `if (argc != N)`: Validating that the expected number of arguments are provided.
- `if (file == NULL)`: Checking if input files exist and are readable.

## Cross-Cutting Concerns

**Logging:** Standard output redirected via SLURM (`%J_stdout.txt`).
**Validation:** Checking results against serial references (e.g., Problem 2).
**Timing:** Performance benchmarking using `MPI_Wtime()` for parallel regions and `clock_gettime()` for serial regions.

---

*Architecture analysis: 2025-05-15*
