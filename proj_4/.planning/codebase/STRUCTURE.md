# Codebase Structure

**Analysis Date:** 2024-07-25

## Directory Layout

```
Khor_Arika_Project_4/
├── Problem_1/        # Cryptocurrency mining problem
│   ├── gpu_mining_starter.cu # Main host code (entry point) for GPU
│   ├── hash_kernel.cu    # CUDA kernel for hashing (part of starter)
│   ├── nonce_kernel.cu   # CUDA kernel for nonce generation
│   ├── support.cu        # Helper functions (e.g., timer)
│   ├── support.h         # Header for support functions
│   ├── Makefile          # Compiles the GPU version
│   ├── P4-1.sbatch       # SLURM script to run the GPU version
│   └── serial/           # Serial (CPU-only) implementation
│       ├── serial_mining.c # Main C code for serial version
│       └── Makefile          # Compiles the serial version
├── Problem_2/        # Likely a continuation of Problem 1 (GPU reduction)
│   ├── Makefile
│   └── P4-2.sbatch
├── Problem_3/        # Image convolution problem
│   ├── Makefile
│   ├── P4-3.sbatch
│   └── serial/
│       ├── convolution_serial.c
│       └── Makefile
├── Problem_4/        # Convolution + Max Pooling problem
│   ├── Makefile
│   ├── P4-4.sbatch
│   └── serial/
│       └── convolution_maxpooling_serial.c
├── autograder_*.py   # Python scripts for automated testing
└── autograder_*.sbatch # SLURM script for autograding
```

## Directory Purposes

**`Khor_Arika_Project_4/`**
- **Purpose:** The root directory for all source code related to the four project problems.
- **Contains:** Subdirectories for each problem and autograder scripts.

**`Khor_Arika_Project_4/Problem_*/`**
- **Purpose:** A self-contained module for a single computational problem.
- **Contains:** CUDA source files (`.cu`, `.h`), a `Makefile` for building the GPU executable, and a `.sbatch` script for execution on an HPC cluster.
- **Key files:** The main `.cu` file (e.g., `gpu_mining_starter.cu`) serves as the entry point.

**`Khor_Arika_Project_4/Problem_*/serial/`**
- **Purpose:** Provides a reference implementation of the problem's logic that runs entirely on the CPU in a serial fashion. This is used for comparison and correctness checking.
- **Contains:** C source files (`.c`) and a `Makefile` to compile them.

**`test_data/`**
- **Purpose:** Contains all input data required to run the problems and verify their outputs.
- **Contains:** CSV files (`.csv`), images (`.jpg`), and expected output files for comparison.

## Key File Locations

**Entry Points:**
- `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`: Main entry point for the GPU implementation of Problem 1.
- `Khor_Arika_Project_4/Problem_1/serial/serial_mining.c`: Main entry point for the serial CPU implementation of Problem 1.
- *(Similar structures exist for Problems 2, 3, and 4).*

**Configuration:**
- `Khor_Arika_Project_4/Problem_*/Makefile`: Contains compiler (`nvcc`) flags, linked libraries, and build targets. Defines the compilation and linking process.
- `Khor_Arika_Project_4/Problem_*/P*-*.sbatch`: SLURM batch scripts that configure the execution environment on an HPC cluster, including which GPU partition to use, module loading (e.g., `module load CUDA`), and the command to execute (`make run`).

**Core Logic:**
- `*kernel.cu` (e.g., `Khor_Arika_Project_4/Problem_1/nonce_kernel.cu`): CUDA kernels define the core parallel computation that runs on the GPU.
- Main `.cu` file (e.g., `gpu_mining_starter.cu`): The host code that orchestrates data movement and kernel launches.
- Serial `.c` file (e.g., `serial_mining.c`): Contains the equivalent logic implemented serially on the CPU.

## Naming Conventions

**Files:**
- CUDA source: `.cu`
- C source: `.c`
- Header files: `.h`
- Kernels: `*_kernel.cu` (e.g., `nonce_kernel.cu`)
- Main GPU executable: Follows the pattern of the main source file (e.g., `gpu_mining_starter`).
- SLURM scripts: `P4-X.sbatch` for problem execution, `autograder_*.sbatch` for testing.

**Directories:**
- Each problem has its own directory: `Problem_1`, `Problem_2`, etc.
- Serial implementations are consistently placed in a `serial/` subdirectory.

## Where to Add New Code

**New Feature (e.g., Optimizing a Step):**
- **GPU Kernel Logic:** Modify or add a `.cu` file containing a `__global__` kernel function within the appropriate `Problem_*/` directory.
- **Host Orchestration:** Modify the main `.cu` file in the `Problem_*/` directory to launch the new kernel and manage necessary data transfers (`cudaMalloc`, `cudaMemcpy`).

**New Problem:**
- Create a new directory: `Problem_5/`.
- Add main host `.cu` file, kernel `.cu` files, `Makefile`, and `.sbatch` script.
- Optionally, create a `Problem_5/serial/` directory with a C implementation for comparison.

## Special Directories

**`serial/`:**
- **Purpose:** Contains a functionally equivalent but serially-executed version of the parallel algorithm. This is crucial for performance comparison and serves as a baseline for correctness.
- **Generated:** No.
- **Committed:** Yes.

---

*Structure analysis: 2024-07-25*
