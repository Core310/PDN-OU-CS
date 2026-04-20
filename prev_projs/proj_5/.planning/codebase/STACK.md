# Technology Stack

**Analysis Date:** 2025-05-14

## Languages

**Primary:**
- C (C99/C11 standards likely) - Used for all core problem implementations (`Problem_1/pingpong_MPI.c`, `Problem_2/dot_product_MPI.c`, etc.).

**Secondary:**
- Python 3 - Used for autograder and testing scripts (`tests/Project_5_Tests/Autograder/`).
- Bash / Shell - Used for SLURM job submission scripts (`*.sbatch`) and build orchestration (`Makefile`).

## Runtime

**Environment:**
- SLURM (Job Scheduler) - Manages job allocation on the cluster.
- OpenMPI 4.1.4 (GCC 11.3.0) - High-performance message-passing library.
- Intel/2022.2 (Compiler/Tooling environment).

**Package Manager:**
- None detected (system-managed modules and OS packages).

## Frameworks

**Core:**
- Message Passing Interface (MPI) - Core standard for distributed memory parallel programming.

**Testing:**
- Custom Python-based Autograder - `tests/Project_5_Tests/Autograder/autograder_project_5.py`.

**Build/Dev:**
- GNU Make - Used for compiling and cleaning build artifacts.

## Key Dependencies

**Critical:**
- `mpi.h` - MPI implementation headers.
- `pandas` - Data manipulation library used in autograder.
- `numpy` - Numerical computing library used in autograder.

**Infrastructure:**
- SLURM Workload Manager - For distributed job execution.

## Configuration

**Environment:**
- Module environment - Modules are loaded via `module load` commands in `.sbatch` scripts.
- Example: `module load intel/2022.2` and `module load OpenMPI/4.1.4-GCC-11.3.0`.

**Build:**
- `Makefile` in each problem directory - Configured to use `mpicc`.

## Platform Requirements

**Development:**
- MPI development environment (e.g., OpenMPI or MPICH).
- GCC or Intel compiler suite.
- Python 3 with `pandas` and `numpy` for testing.

**Production:**
- HPC Cluster with SLURM scheduler (e.g., OUCSPDN cluster).

---

*Stack analysis: 2025-05-14*
