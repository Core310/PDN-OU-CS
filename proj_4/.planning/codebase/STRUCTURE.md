# Codebase Structure

**Analysis Date:** 2024-07-31

## Directory Layout

The project is organized into separate directories for each problem defined in the project instructions.

```
Khor_Arika_Project_4/
├── Problem_1/        # Code and data for the GPU Mining Hash Offload problem
├── Problem_2/        # Code and data for the GPU Reduction problem
├── Problem_3/        # Code and data for the Convolution problem
├── Problem_4/        # Code and data for the Max Pooling problem
├── autograder_*.py   # Python scripts for automated grading
└── *.sbatch          # Slurm batch scripts for running jobs on a cluster
```

A typical problem directory has the following structure:

```
Problem_N/
├── *.cu              # CUDA source files (host and device code)
├── *.h               # Header files
├── Makefile          # Build script for compiling the CUDA code
├── P4-N.sbatch       # Slurm batch script to run this specific problem
├── *.csv             # Output data files (results, timings)
└── serial/           # Directory for the reference serial (CPU) implementation
    ├── *.c           # C source file for the serial version
    └── Makefile      # Build script for the serial version
```

## Directory Purposes

**`Khor_Arika_Project_4/`**
- **Purpose:** The root directory for all source code related to the project.
- **Contains:** Subdirectories for each distinct programming problem.

**`Khor_Arika_Project_4/Problem_*/`**
- **Purpose:** To isolate all files related to a single, specific problem (e.g., convolution).
- **Contains:** The CUDA implementation, build scripts, execution scripts, and output files for that problem.
- **Key files:** `*.cu` (CUDA source), `Makefile` (build), `P4-N.sbatch` (run).

**`Khor_Arika_Project_4/Problem_*/serial/`**
- **Purpose:** To house the serial (CPU-only) reference implementation of the problem's algorithm.
- **Contains:** A standard C source file (`.c`) and a corresponding `Makefile`. This allows for direct performance and correctness comparison against the GPU version.

**`test_data/`**
- **Purpose:** Contains sample input data and expected output data for testing the various problems.

## Key File Locations

**Entry Points:**
- `Khor_Arika_Project_4/Problem_*/<problem_name>.cu`: The `main` function within these files serves as the entry point for the host-side application that drives the GPU computation. For example, `Khor_Arika_Project_4/Problem_3/convolution_CUDA.cu`.
- `Khor_Arika_Project_4/Problem_*/serial/<serial_name>.c`: The `main` function in these files is the entry point for the CPU-only reference implementation.

**Configuration:**
- `Khor_Arika_Project_4/Problem_*/Makefile`: Contains the build configuration, including compiler flags (`NVCC_FLAGS`), libraries (`LD_FLAGS`), and dependencies for `nvcc` (the NVIDIA CUDA Compiler).

**Core Logic (GPU Kernels):**
- `Khor_Arika_Project_4/Problem_*/kernel.cu` or other `*.cu` files: These files contain the `__global__` functions that are executed on the GPU device. Often, they are directly included (`#include`) into the main driver `.cu` file.
- `Khor_Arika_Project_4/Problem_1/` has multiple kernel files: `hash_kernel.cu`, `nonce_kernel.cu`, `reduction_kernel.cu`.

**Testing:**
- `autograder_*.py`: These scripts are used to automate the process of running the compiled programs with test data and verifying the output against expected results.
- `*.sbatch`: Slurm batch scripts define the environment and commands to run the executables on an HPC cluster, serving as a form of integration test configuration.

## Naming Conventions

**Files:**
- CUDA source files use the `.cu` extension.
- C source files use the `.c` extension.
- Header files use the `.h` extension.
- Executables are typically named after their function, e.g., `convolution_CUDA`.
- Kernels are often in files named `kernel.cu` or named after their specific function, e.g., `hash_kernel.cu`.

**Directories:**
- Each major part of the project is housed in a `Problem_N` directory.
- `serial/` is consistently used for the CPU-only reference code.

## Where to Add New Code

**New Feature (Problem):**
- Create a new directory `Problem_5/`.
- Inside `Problem_5/`, create the main driver `.cu` file, kernel `.cu` files, a `support.h`/`.cu` pair if needed, and a `Makefile`.
- Create a `Problem_5/serial/` subdirectory with the C reference implementation and its own `Makefile`.
- Add a new `P4-5.sbatch` script for execution.

**New GPU Kernel:**
- If for an existing problem, define the new `__global__` function in a relevant `.cu` file (e.g., `kernel.cu`) or a new file (e.g., `new_feature_kernel.cu`).
- Include the new kernel file in the main driver `.cu` if necessary.
- Update the `Makefile` if a new source file was added to the compilation chain.

**Utilities:**
- Shared helper functions (e.g., for timing, I/O) should be placed in the local `support.cu` and `support.h` files within a problem's directory. There is no project-wide shared support library.

---

*Structure analysis: 2024-07-31*
