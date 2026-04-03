#!/bin/bash
#SBATCH --partition=oucspdn_cpu
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
#SBATCH --output=out/_P5-3_diff_%J_stdout.txt
#SBATCH --error=out/_P5-3_diff_%J_stderr.txt

#################################################

echo "Working directory:"
pwd
echo ""

module load OpenMPI/4.1.4-GCC-11.3.0

# Compile the code
make -C Problem_3 clean && make -C Problem_3

echo "--- Starting runs ---"

# (Project_5_Instructions.pdf, Page 9)
# Processes: 4 on different nodes. Sizes: 262144, 524288, 1048576.

srun -n 4 ./Problem_3/merge_sort_MPI 262144 tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv Problem_3/result_4p_18_diff.csv Problem_3/time_4p_18_diff.csv
srun -n 4 ./Problem_3/merge_sort_MPI 524288 tests/Project_5_Tests/test_data/Vectors/vec1_2^19.csv Problem_3/result_4p_19_diff.csv Problem_3/time_4p_19_diff.csv
srun -n 4 ./Problem_3/merge_sort_MPI 1048576 tests/Project_5_Tests/test_data/Vectors/vec1_2^20.csv Problem_3/result_4p_20_diff.csv Problem_3/time_4p_20_diff.csv
