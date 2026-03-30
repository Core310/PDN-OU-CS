# Codebase Structure

**Analysis Date:** 2025-05-15

## Directory Layout

```
proj_5/
├── Problem_1/          # Ping-Pong MPI problem
│   ├── Makefile        # Build instructions for pingpong_MPI
│   ├── pingpong_MPI.c  # Source code (stub)
│   ├── pingpong_diffnode.sbatch  # SLURM script for different nodes
│   └── pingpong_samenode.sbatch  # SLURM script for same node
├── Problem_2/          # Dot Product MPI problem
│   ├── Makefile        # Build instructions for dot_product_MPI
│   ├── dot_product.sbatch # SLURM script for dot product
│   └── serial/         # Serial implementation
│       ├── dotprod_serial.c # Serial source code (complete)
│       ├── Makefile    # Build instructions for serial version
│       └── prob3_serial.sbatch # SLURM script for serial version (Note: misnamed as prob3?)
├── Problem_3/          # Merge Sort MPI problem
│   ├── Makefile        # Build instructions for merge_sort_MPI
│   ├── merge_sort_MPI.c # Source code (stub)
│   ├── merge_sort_diffnode.sbatch # SLURM script for different nodes
│   └── merge_sort_samenode.sbatch # SLURM script for same node
├── Problem_4/          # Pi calculation MPI problem
│   ├── Makefile        # Build instructions for pi_MPI
│   └── pi.sbatch       # SLURM script for pi calculation
└── Project_5_Instructions.docx # Project instructions
```

## Directory Purposes

**Problem_1:**
- Purpose: Implementation of MPI Ping-Pong messaging pattern.
- Contains: MPI source, Makefile, SLURM scripts.
- Key files: `Problem_1/pingpong_MPI.c`

**Problem_2:**
- Purpose: Implementation of Parallel Dot Product using MPI.
- Contains: Makefile, SLURM scripts, and a `serial` subdirectory.
- Key files: `Problem_2/serial/dotprod_serial.c` (Serial reference implementation)

**Problem_3:**
- Purpose: Implementation of Parallel Merge Sort using MPI.
- Contains: MPI source, Makefile, SLURM scripts.
- Key files: `Problem_3/merge_sort_MPI.c`

**Problem_4:**
- Purpose: Implementation of Pi calculation using MPI (likely Monte Carlo or Trapezoidal).
- Contains: Makefile, SLURM scripts.
- Key files: `Problem_4/Makefile` (Missing source `pi_MPI.c`)

## Key File Locations

**Entry Points:**
- `Problem_1/pingpong_MPI.c`: Entry for Problem 1 MPI implementation.
- `Problem_2/serial/dotprod_serial.c`: Entry for Problem 2 serial implementation.
- `Problem_3/merge_sort_MPI.c`: Entry for Problem 3 MPI implementation.

**Configuration:**
- `Problem_1/Makefile`: Build configuration for Problem 1.
- `Problem_2/Makefile`: Build configuration for Problem 2 MPI.
- `Problem_2/serial/Makefile`: Build configuration for Problem 2 serial.
- `Problem_3/Makefile`: Build configuration for Problem 3.
- `Problem_4/Makefile`: Build configuration for Problem 4.

**Testing:**
- `Problem_1/pingpong_samenode.sbatch`: Job script for testing Problem 1 on the same node.
- `Problem_1/pingpong_diffnode.sbatch`: Job script for testing Problem 1 on different nodes.
- `Problem_2/dot_product.sbatch`: Job script for testing Problem 2 MPI.
- `Problem_2/serial/prob3_serial.sbatch`: Job script for testing Problem 2 serial (note potential naming confusion).
- `Problem_3/merge_sort_samenode.sbatch`: Job script for testing Problem 3 on the same node.
- `Problem_4/pi.sbatch`: Job script for testing Problem 4 MPI.

## Naming Conventions

**Files:**
- [Pattern]: `[problem_name]_MPI.c` for MPI implementations.
- [Pattern]: `[problem_name].sbatch` for SLURM job scripts.
- [Pattern]: `Makefile` for build instructions.

**Directories:**
- [Pattern]: `Problem_[N]` for each project task.

## Where to Add New Code

**New Feature:**
- MPI Implementations: `Problem_[N]/[name]_MPI.c`
- Serial References: `Problem_[N]/serial/[name]_serial.c`

**Utilities:**
- MPI Helpers: Typically included in the main MPI source file or as separate headers if needed (none detected yet).

## Special Directories

**Problem_2/serial/:**
- Purpose: Contains the serial reference implementation for comparison with the parallel version.
- Generated: No
- Committed: Yes

---

*Structure analysis: 2025-05-15*
