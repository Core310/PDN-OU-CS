# Technology Stack

**Analysis Date:** 2024-07-25

## Languages

**Primary:**
- C++/CUDA - Used for the core GPU computation kernels and application logic in `Khor_Arika_Project_4/Problem_*/*.cu`.
- C - Used for serial, CPU-only versions of the algorithms for comparison, found in `Khor_Arika_Project_4/Problem_*/serial/*.c`.

**Secondary:**
- Python 3.12.3 - Used for autograding scripts (`autograder_*.py`) that orchestrate tests and verify results.

## Runtime

**Environment:**
- The core application is compiled C++/CUDA code that runs as native executables on a Linux environment with an NVIDIA GPU.
- Python scripts run using the Python 3.12.3 interpreter located in the `.venv/` directory.

**Package Manager:**
- `pip` is used for Python dependencies.
- A virtual environment exists at `.venv/`, but no `requirements.txt` or `pyproject.toml` is present in the root. Dependencies are installed directly.

## Frameworks

**Core:**
- NVIDIA CUDA - The fundamental framework for GPU programming. Used for writing kernels and managing GPU-CPU data transfers.

**Testing:**
- The project uses custom Python scripts (`autograder_*.py`) for testing and validation, not a standard testing framework like PyTest or Google Test.

**Build/Dev:**
- `make` - Used to orchestrate the compilation of C and CUDA source files via `Makefile`s.
- `nvcc` (NVIDIA CUDA Compiler) - The compiler for all `.cu` files.
- `gcc` - The compiler for serial C (`.c`) files.

## Key Dependencies

**Python (for Autograding):**
- `numpy` - Used for numerical operations and handling array data in autograding scripts.
- `pandas` - Used to read, manipulate, and compare data from `.csv` files, which serve as inputs and outputs for the programs.

**C++/CUDA:**
- CUDA Toolkit - A hard dependency. The Makefiles point to `/usr/local/cuda/include` and `/usr/local/cuda/lib64`, indicating a standard installation path is expected.

## Configuration

**Build:**
- Build configuration is managed through `Makefile`s located in each problem directory (e.g., `Khor_Arika_Project_4/Problem_1/Makefile`). These define compiler flags and linking.

## Platform Requirements

**Development & Production:**
- A Linux-based OS.
- An NVIDIA GPU with a compatible CUDA driver.
- The NVIDIA CUDA Toolkit installed.
- `make`, `gcc`, and `python`.
---
*Stack analysis: 2024-07-25*
