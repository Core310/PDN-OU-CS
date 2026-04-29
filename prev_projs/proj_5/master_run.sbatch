#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=8
#SBATCH --time=00:30:00
#SBATCH --job-name=Master_Project_5
#SBATCH --output=out/master_P5_%J_stdout.txt
#SBATCH --error=out/master_P5_%J_stderr.txt
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL

echo "--- Master Execution Script for Project 5 ---"
date
echo "Working directory: $(pwd)"
echo ""

# Load required modules
module load OpenMPI/4.1.4-GCC-11.3.0
module load python/3.10.8-GCCcore-12.2.0 # Adjust if necessary for Schooner

# Create output directory if it doesn't exist
mkdir -p out

echo "--- Phase 1: Compiling all problems ---"
make -C Problem_1 clean && make -C Problem_1
make -C Problem_2 clean && make -C Problem_2
make -C Problem_3 clean && make -C Problem_3
make -C Problem_4 clean && make -C Problem_4
echo ""

echo "--- Phase 2: Running Benchmarks ---"

echo "Problem 1: Ping-Pong (Same Node)"
mpirun -n 2 ./Problem_1/pingpong_MPI 1000000 Problem_1/time_1M_same.csv
mpirun -n 2 ./Problem_1/pingpong_MPI 2000000 Problem_1/time_2M_same.csv
mpirun -n 2 ./Problem_1/pingpong_MPI 4000000 Problem_1/time_4M_same.csv
mpirun -n 2 ./Problem_1/pingpong_MPI 8000000 Problem_1/time_8M_same.csv

echo "Problem 2: Dot Product"
mpirun -n 8 ./Problem_2/dot_product_MPI 1048576 tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^20.csv Problem_2/result_8p_20.csv Problem_2/time_8p_20.csv
# (Add other runs if needed, but this is a representative run)

echo "Problem 3: Merge Sort"
mpirun -n 8 ./Problem_3/merge_sort_MPI 1048576 tests/Project_5_Tests/test_data/Problem_3/input_2^20.csv Problem_3/result_8p_20.csv Problem_3/time_8p_20.csv

echo "Problem 4: Monte Carlo Pi"
mpirun -n 8 ./Problem_4/pi_MPI Problem_4/result_8p.csv Problem_4/time_8p.csv
echo ""

echo "--- Phase 3: Running Autograder ---"
# Check if venv exists and activate it
if [ -d "venv" ]; then
    source venv/bin/activate
    python tests/Project_5_Tests/Autograder/autograder_project_5.py
    deactivate
else
    echo "Warning: venv not found. Attempting to run with system python."
    python3 tests/Project_5_Tests/Autograder/autograder_project_5.py
fi

echo ""
echo "--- Master Execution Finished ---"
date
