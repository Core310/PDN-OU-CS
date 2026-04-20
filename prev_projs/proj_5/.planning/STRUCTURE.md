# Project Structure: Project 5 (MPI Programming)

## Directory Layout
- `Problem_1/`: Ping-Pong communication
  - `pingpong_MPI.c`: Source code
  - `Makefile`: Build instructions
  - `pingpong_diffnode.sbatch`: Different compute nodes
  - `pingpong_samenode.sbatch`: One compute node
- `Problem_2/`: Parallel Dot Product
  - `dot_product_MPI.c`: Source code
  - `Makefile`: Build instructions
  - `dot_product.sbatch`: SLURM script
- `Problem_3/`: Parallel Merge Sort
  - `merge_sort_MPI.c`: Source code
  - `Makefile`: Build instructions
  - `merge_sort_diffnode.sbatch`: Different compute nodes
  - `merge_sort_samenode.sbatch`: One compute node
- `Problem_4/`: Monte Carlo Pi Estimation
  - `pi_MPI.c`: Source code
  - `Makefile`: Build instructions
  - `pi.sbatch`: SLURM script
- `out/`: SLURM output and error files (on Schooner)
- `.planning/`: Project management files
- `CODING_GUIDELINES.md`: Coding standards

## Required Submission Structure
The final ZIP file (`Lastname_Firstname_Project_5.zip`) must contain:
- `Problem_1/` (pingpong_MPI.c, Makefile, sbatches)
- `Problem_2/` (dot_product_MPI.c, Makefile, sbatch)
- `Problem_3/` (merge_sort_MPI.c, Makefile, sbatches)
- `Problem_4/` (pi_MPI.c, Makefile, sbatch)
- Autograder scripts as provided.

## Test Data
- Test data and autograder should be located at `/home/oucspdnta/current/test_data/Project_5_Tests/` on Schooner.
- Locally, a `tests/` directory may be used for preliminary verification.
