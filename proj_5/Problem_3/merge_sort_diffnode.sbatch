#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=4
#
#SBATCH --time=00:15:00
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --job-name=hw5prob3_diff
#
#SBATCH --chdir=/home/arika/Documents/PDN-OU-CS/proj_5/Problem_3
#SBATCH --output=/home/arika/Documents/PDN-OU-CS/proj_5/out/_P5-3_diff_%J_stdout.txt
#SBATCH --error=/home/arika/Documents/PDN-OU-CS/proj_5/out/_P5-3_diff_%J_stderr.txt

#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0

# Compile the code
make clean && make

echo "--- Starting runs ---"

# (Project_5_Instructions.pdf, Page 9)
# Processes: 4 on different nodes. Sizes: 262144, 524288, 1048576.

mpirun -n 4 ./merge_sort_MPI 262144 ../tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv result_4p_18_diff.csv time_4p_18_diff.csv
mpirun -n 4 ./merge_sort_MPI 524288 ../tests/Project_5_Tests/test_data/Vectors/vec1_2^19.csv result_4p_19_diff.csv time_4p_19_diff.csv
mpirun -n 4 ./merge_sort_MPI 1048576 ../tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv result_4p_20_diff.csv time_4p_20_diff.csv
