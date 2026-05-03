#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=1
#
#SBATCH --time=00:15:00
#SBATCH --job-name=hw5prob3
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=ephraim.j.wong-1@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --chdir=/home/oucspdn076/Project_5/Wong_Ephraim_Project_5/Problem_3
#SBATCH --output=/home/oucspdn076/AutogradingOutput/Project_5/Problem_3/P5-3_%J_stdout.txt
#SBATCH --error=/home/oucspdn076/AutogradingOutput/Project_5/Problem_3/P5-3_%J_stderr.txt

#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0

mpirun -n 2 ./merge_sort_MPI 262144 ../../test_data/Vectors/vec1_2^18.csv result_2_diff_18.csv time_2_diff_18.csv
# add more here ...
mpirun -n 2 ./merge_sort_MPI 524288 ../../test_data/Vectors/vec1_2^19.csv result_2_diff_19.csv time_2_diff_19.csv
mpirun -n 2 ./merge_sort_MPI 1048576 ../../test_data/Vectors/vec1_2^20.csv result_2_diff_20.csv time_2_diff_20.csv
