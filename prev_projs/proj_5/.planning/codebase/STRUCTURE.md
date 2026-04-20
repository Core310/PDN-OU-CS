# Codebase Structure

**Analysis Date:** 2025-03-30

## Directory Layout

```
proj_5/
├── Problem_1/          # Ping-Pong MPI problem
│   ├── Makefile        # Build instructions for pingpong_MPI
│   ├── pingpong_MPI.c  # Source code (complete)
│   ├── pingpong_diffnode.sbatch  # SLURM script for different nodes
│   └── pingpong_samenode.sbatch  # SLURM script for same node
├── Problem_2/          # Dot Product MPI problem
│   ├── Makefile        # Build instructions for dot_product_MPI
│   ├── dot_product_MPI.c # Source code (stub)
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
│   ├── pi_MPI.c        # Source code (stub)
│   └── pi.sbatch       # SLURM script for pi calculation
├── tests/              # Testing suite
│   └── Project_5_Tests/
│       ├── Autograder/ # Automated grading logic
│       │   ├── autograder_base.py
│       │   ├── autograder_problem_5_2.py
│       │   ├── autograder_problem_5_3.py
│       │   ├── autograder_problem_5_4.py
│       │   ├── autograder_project_5.py
│       │   ├── autograder_project_5.sbatch
│       │   └── test_scripts/
│       └── test_data/  # CSV data for testing (vectors, expected outputs)
└── Project_5_Instructions.pdf # Project instructions
```

## Directory Purposes

**Problem_1:**
- Purpose: Distributed messaging latency measurements via Ping-Pong.
- Contains: MPI source, Makefile, and SLURM scripts for intra-node and inter-node testing.
- Key files: `Problem_1/pingpong_MPI.c`.

**Problem_2:**
- Purpose: Vector dot product implementation in parallel.
- Contains: MPI stub, Makefile, SLURM scripts, and a `serial` subdirectory.
- Key files: `Problem_2/dot_product_MPI.c`, `Problem_2/serial/dotprod_serial.c`.

**Problem_3:**
- Purpose: Sorting large arrays using parallel merge sort.
- Contains: MPI stub with basic I/O helpers, Makefile, and SLURM scripts.
- Key files: `Problem_3/merge_sort_MPI.c`.

**Problem_4:**
- Purpose: Approximating Pi using the Monte Carlo method.
- Contains: MPI stub, Makefile, and SLURM scripts.
- Key files: `Problem_4/pi_MPI.c`.

**tests/:**
- Purpose: Houses the automated grading framework and test datasets.
- Contains: Python scripts for testing (`autograder_*.py`), shell scripts for batch runs (`test_scripts/`), and reference CSV files.

## Key File Locations

**Entry Points (MPI Implementations):**
- `Problem_1/pingpong_MPI.c`
- `Problem_2/dot_product_MPI.c`
- `Problem_3/merge_sort_MPI.c`
- `Problem_4/pi_MPI.c`

**Entry Point (Serial Reference):**
- `Problem_2/serial/dotprod_serial.c`

**Build Configuration:**
- `Problem_1/Makefile`
- `Problem_2/Makefile`
- `Problem_2/serial/Makefile`
- `Problem_3/Makefile`
- `Problem_4/Makefile`

**SLURM Execution:**
- `Problem_1/pingpong_samenode.sbatch`
- `Problem_1/pingpong_diffnode.sbatch`
- `Problem_2/dot_product.sbatch`
- `Problem_3/merge_sort_samenode.sbatch`
- `Problem_4/pi.sbatch`

## Naming Conventions

**Files:**
- [Pattern]: `[problem_name]_MPI.c` for parallel implementation files.
- [Pattern]: `*.sbatch` for cluster job scripts.
- [Pattern]: `Makefile` for build instructions.
- [Pattern]: `*.csv` for data input/output.

**Directories:**
- [Pattern]: `Problem_[N]` for each problem task.
- [Pattern]: `serial/` for serial versions of problems.

## Where to Add New Code

**New Problem Logic:**
- Implement MPI logic in the corresponding `Problem_N/[name]_MPI.c` file.
- Update `Makefile` if new source files are added.

**New Utility Functions:**
- Common helpers should be added to the respective MPI source file (local to problem) or a shared header if needed across problems.

**New Tests:**
- Test data: `tests/Project_5_Tests/test_data/[Problem_N]/`
- Autograder scripts: `tests/Project_5_Tests/Autograder/`

## Special Directories

**tests/Project_5_Tests/test_data/:**
- Purpose: Contains critical vector data and expected result files for validation.
- Generated: No (provided)
- Committed: Yes

**Problem_2/serial/:**
- Purpose: Holds the serial baseline implementation for Problem 2.
- Generated: No
- Committed: Yes

---

*Structure analysis: 2025-03-30*
