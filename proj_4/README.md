# CUDA Codebase Refactoring and Optimization

This repository contains a refactored and optimized suite of CUDA applications for cryptocurrency mining, 2D convolution, and max-pooling.

## Project Structure

- `Khor_Arika_Project_4/`
    - `common/`: Centralized support code (timers, error handling).
    - `Problem_1/`: Cryptocurrency mining application with full GPU reduction.
    - `Problem_2/`: Standalone optimized GPU reduction.
    - `Problem_3/`: 2D tiled convolution using dynamic shared memory.
    - `Problem_4/`: Integrated convolution and max-pooling pipeline.
    - `serial/`: Reference serial implementations.
    - `tests/`: GTest-based unit testing suite for CUDA kernels.

## Building and Running

### Prerequisites
- NVIDIA CUDA Toolkit
- Google Test (GTest) headers and libraries

### Compilation
To compile all problems, navigate to their respective directories and run `make`.

### Running Applications

#### Mining (Problem 1 & 2)
```bash
./gpu_mining_problem1 <transactions.csv> <n_transactions> <trials> <out.csv> <time.csv> [BLOCK_SIZE]
```
- `BLOCK_SIZE` (optional): Thread block size (default: 1024).

#### Convolution (Problem 3 & 4)
```bash
./convolution_CUDA <n_row> <n_col> <input.csv> <results.csv> <time.csv> [BLOCK_SIZE] [RADIUS]
```
- `BLOCK_SIZE` (optional): Side of square thread block (default: 16, resulting in 16x16 blocks).
- `RADIUS` (optional): Filter radius (default: 2, resulting in a 5x5 filter).

## Testing

### Unit Tests
To build and run the unit testing suite:
```bash
cd Khor_Arika_Project_4/tests
make test
```
The suite verifies kernel correctness across various grid/block dimensions and radii.

### Autograders
To run the full project validation:
```bash
cd Khor_Arika_Project_4
source ../.venv/bin/activate
python3 autograder_project_4.py
```

## Key Optimizations
- **Full GPU Reduction:** Replaced hybrid CPU/GPU bottleneck with 64-bit atomic-based on-device reduction.
- **Dynamic Shared Memory:** Convolution kernels utilize `extern __shared__` to handle runtime-configurable tile sizes.
- **Robust Error Handling:** Unified `gpuErrchk` macro integrated project-wide.
