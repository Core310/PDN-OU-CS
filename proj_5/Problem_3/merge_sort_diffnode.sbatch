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
#SBATCH --chdir=/home/oucspdn089/git/PDN-OU-CS/proj_5/Problem_3
#SBATCH --output=/home/oucspdn089/git/PDN-OU-CS/proj_5/out/_P5-3_diff_%J_stdout.txt
#SBATCH --error=/home/oucspdn089/git/PDN-OU-CS/proj_5/out/_P5-3_diff_%J_stderr.txt

#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0

# (Project_5_Instructions.pdf, Page 9)
# Processes: 4 on different nodes. Sizes: 262144, 524288, 1048576.

mpirun -n 4 ./merge_sort_MPI 262144 ../test_data/Problem_3/vec_3_18.csv output_18_diff.csv time_18_diff.csv
mpirun -n 4 ./merge_sort_MPI 524288 ../test_data/Problem_3/vec_3_19.csv output_19_diff.csv time_19_diff.csv
mpirun -n 4 ./merge_sort_MPI 1048576 ../test_data/Problem_3/vec_3_20.csv output_20_diff.csv time_20_diff.csv
