# Architecture

**Analysis Date:** 2025-03-30

## Pattern Overview

**Overall:** MPI-based Distributed Computing (SPMD pattern)

**Key Characteristics:**
- **Single Program Multiple Data (SPMD):** The same executable is run across multiple MPI ranks, with logic branching based on rank.
- **Message Passing:** Explicit data transfer between ranks using `MPI_Send`, `MPI_Recv`, `MPI_Scatter`, `MPI_Gather`, and `MPI_Reduce`.
- **Task Parallelism:** Workload is partitioned into independent tasks (segments of arrays, random samples for Pi) distributed across processes.

## Layers

**Task Management (SLURM):**
- Purpose: Resource allocation and job scheduling on the cluster.
- Location: `Problem_*/[name].sbatch` and `tests/Project_5_Tests/Autograder/autograder_project_5.sbatch`
- Contains: Node count, task count, memory requirements, and execution commands (`mpirun`).
- Depends on: Cluster infrastructure (Slurm).
- Used by: Researchers/Developers running the problems.

**Parallel Implementation (MPI):**
- Purpose: Distributed logic for solving individual problems.
- Location: `Problem_*/[name]_MPI.c`
- Contains: MPI initialization (`MPI_Init`), rank identification (`MPI_Comm_rank`), communication, and synchronization.
- Depends on: MPI library (e.g., OpenMPI).
- Used by: Compiled binaries.

**Serial Reference (Problem 2):**
- Purpose: Providing a baseline for correctness and performance comparison.
- Location: `Problem_2/serial/dotprod_serial.c`
- Contains: Standard single-threaded logic for dot product.

**Testing & Validation (Python/Shell):**
- Purpose: Automated grading and verification of outputs.
- Location: `tests/Project_5_Tests/Autograder/`
- Contains: Python scripts that run binaries and compare outputs against expected values in `test_data/`.

## Data Flow

**Standard MPI Pattern:**

1. **Initialization:** `MPI_Init` sets up the communicator; ranks and size are retrieved.
2. **Distribution:**
    - For Ping-Pong: Peer-to-peer sending between rank 0 and 1.
    - For Dot Product/Merge Sort: Rank 0 usually reads input files (`.csv`) and distributes data using `MPI_Scatter` or `MPI_Send`.
3. **Local Computation:** Each rank performs its share of the workload (e.g., local sorting, local sum).
4. **Collection/Reduction:**
    - Dot Product: `MPI_Reduce` or `MPI_Gather` to aggregate local sums.
    - Merge Sort: `MPI_Gather` or recursive merging between ranks.
    - Pi Calculation: `MPI_Reduce` to sum up hits.
5. **Output:** Rank 0 writes the aggregated result and timing (`MPI_Wtime`) to specified CSV files.

**State Management:**
- Distributed memory architecture; each MPI rank has its own address space. State sharing is done exclusively through message passing.

## Key Abstractions

**MPI Communicator:**
- Purpose: Group of processes that can communicate with each other.
- Examples: `MPI_COMM_WORLD` used in all problems.

**Rank-Based Logic:**
- Purpose: Determining which process performs which task (e.g., Rank 0 as master/coordinator).
- Pattern: `if (my_rank == 0) { ... } else { ... }`

## Entry Points

**Ping-Pong MPI:**
- Location: `Problem_1/pingpong_MPI.c`
- Triggers: SLURM job `pingpong_samenode.sbatch` or `pingpong_diffnode.sbatch`.

**Dot Product MPI:**
- Location: `Problem_2/dot_product_MPI.c`
- Triggers: SLURM job `dot_product.sbatch`.

**Merge Sort MPI:**
- Location: `Problem_3/merge_sort_MPI.c`
- Triggers: SLURM job `merge_sort_samenode.sbatch` or `merge_sort_diffnode.sbatch`.

**Monte Carlo Pi MPI:**
- Location: `Problem_4/pi_MPI.c`
- Triggers: SLURM job `pi.sbatch`.

## Error Handling

**Strategy:** Validation of command-line arguments and file existence checks.

**Patterns:**
- `if (argc != EXPECTED)`: Terminates early if arguments are missing.
- `if (my_rank == 0) { printf("Usage..."); }`: Master rank notifies user of errors.

## Cross-Cutting Concerns

**Logging:** Standard output and error redirected to `.txt` files by SLURM.
**Timing:** High-precision benchmarking using `MPI_Wtime()`.
**Resource Cleanup:** `MPI_Finalize()` called before exit; memory freed with `free()`.

---

*Architecture analysis: 2025-03-30*
