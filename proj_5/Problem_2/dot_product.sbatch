#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks=8
#
#SBATCH --time=00:15:00
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --job-name=hw5prob2
#
#SBATCH --output=out/_P5-2_%J_stdout.txt
#SBATCH --error=out/_P5-2_%J_stderr.txt
#
#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0
source "$ONEAPI/setvars.sh"

# Compile the code in its directory
make -C Problem_2 clean && make -C Problem_2

echo "--- Starting runs ---"

# (Project_5_Instructions.pdf, Page 6)
# All paths are now relative to the project root

srun -n 2 ./Problem_2/dot_product_MPI 262144 tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^18.csv Problem_2/result_2p_18.csv Problem_2/time_2p_18.csv
srun -n 4 ./Problem_2/dot_product_MPI 262144 tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^18.csv Problem_2/result_4p_18.csv Problem_2/time_4p_18.csv
srun -n 8 ./Problem_2/dot_product_MPI 262144 tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^18.csv Problem_2/result_8p_18.csv Problem_2/time_8p_18.csv

srun -n 2 ./Problem_2/dot_product_MPI 524288 tests/Project_5_Tests/test_data/Vectors/vec1_2^19.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^19.csv Problem_2/result_2p_19.csv Problem_2/time_2p_19.csv
srun -n 4 ./Problem_2/dot_product_MPI 524288 tests/Project_5_Tests/test_data/Vectors/vec1_2^19.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^19.csv Problem_2/result_4p_19.csv Problem_2/time_4p_19.csv
srun -n 8 ./Problem_2/dot_product_MPI 524288 tests/Project_5_Tests/test_data/Vectors/vec1_2^19.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^19.csv Problem_2/result_8p_19.csv Problem_2/time_8p_19.csv

srun -n 2 ./Problem_2/dot_product_MPI 1048576 tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^20.csv Problem_2/result_2p_20.csv Problem_2/time_2p_20.csv
srun -n 4 ./Problem_2/dot_product_MPI 1048576 tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^20.csv Problem_2/result_4p_20.csv Problem_2/time_4p_20.csv
srun -n 8 ./Problem_2/dot_product_MPI 1048576 tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^20.csv Problem_2/result_8p_20.csv Problem_2/time_8p_20.csv
