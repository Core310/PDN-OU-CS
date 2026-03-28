# Technology Stack

**Analysis Date:** 2024-07-25

## Languages

**Primary:**
- **CUDA C++:** Used for all GPU kernel implementations and host-side control logic. The version is determined by the CUDA Toolkit.
- **C:** Used for serial implementations and helper functions.

**Secondary:**
- **Bash:** Used in `.sbatch` scripts for job submission and environment setup.

## Runtime

**Environment:**
- **Slurm Workload Manager:** The project is designed to be run on a High-Performance Computing (HPC) cluster using Slurm for job scheduling.
- **CUDA Platform:** Executes on NVIDIA GPUs. The `.sbatch` files specify `CUDA/10.1.243`.

**Compiler:**
- **NVCC (NVIDIA CUDA C/C++ Compiler):** The primary compiler for `.cu` files, specified in `Makefile`.
- **GCC (GNU Compiler Collection):** Used as the host compiler by `nvcc`. The `.sbatch` files specify `GCC/8.3.0`.

**Package Manager:**
- **Make:** The `make` utility is used as the build system.
- **Dependencies:** Dependencies like the CUDA Toolkit are managed via environment modules on the HPC cluster (`module load CUDA/...`). There is no traditional package manager lockfile.

## Frameworks

**Core:**
- **NVIDIA CUDA:** The core framework for developing applications that run on NVIDIA GPUs. The project uses CUDA for parallel computations like hashing and convolution.

**Testing:**
- No formal testing framework (like Jest or PyTest) was detected. Testing appears to be done through direct execution and validation of output files. Autograding scripts (`autograder_*.py`) are present, suggesting a Python-based external validation system.

**Build/Dev:**
- **Make:** Used to orchestrate the compilation process via `Makefile`.

## Key Dependencies

**Critical:**
- **CUDA Toolkit:** Essential for compilation (`nvcc`) and runtime (`-lcudart`). The project relies on headers like `cuda_runtime_api.h` and `curand_kernel.h`.

**Infrastructure:**
- **Slurm:** Required for job submission and execution on the target HPC environment.

## Configuration

**Build:**
- **`Makefile`:** Located in each `Problem_*` directory, these files define compiler flags (`-O3`), include paths (`-I/usr/local/cuda/include`), linker flags, and build targets.

**Runtime:**
- **`.sbatch` files:** These scripts configure the Slurm job, requesting resources (e.g., GPU partitions), setting time limits, and defining the execution commands (`make run`). They also load the required CUDA and GCC versions.

## Platform Requirements

**Development & Production:**
- A Linux-based OS.
- An NVIDIA GPU compatible with CUDA 10.1.
- NVIDIA CUDA Toolkit v10.1.243 installed.
- GCC v8.3.0.
- `make` utility.
- Slurm for running the provided `.sbatch` scripts.

---

*Stack analysis: 2024-07-25*
