#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks-per-node=2
#SBATCH --ntasks=2
#
#SBATCH --time=00:15:00
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --job-name=hw5prob1_same
#
#SBATCH --output=out/_P5-1_same_%J_stdout.txt
#SBATCH --error=out/_P5-1_same_%J_stderr.txt
#
#################################################

echo "Working directory:"
pwd
echo ""

module load OpenMPI/4.1.4-GCC-11.3.0

# Compile the code
make -C Problem_1 clean && make -C Problem_1

echo "--- Starting runs ---"

# (Project_5_Instructions.pdf, Page 4)
# "Calculate the communication time for arrays of 1 million, 2 million, 4 million, and 8 million integers."

srun -n 2 ./Problem_1/pingpong_MPI 1000000 Problem_1/time_1M_same.csv
srun -n 2 ./Problem_1/pingpong_MPI 2000000 Problem_1/time_2M_same.csv
srun -n 2 ./Problem_1/pingpong_MPI 4000000 Problem_1/time_4M_same.csv
srun -n 2 ./Problem_1/pingpong_MPI 8000000 Problem_1/time_8M_same.csv
