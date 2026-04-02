#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks-per-node=16
#SBATCH --ntasks=16
#
#SBATCH --time=00:15:00
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --job-name=hw5prob4
#
#SBATCH --output=out/_P5-4_%J_stdout.txt
#SBATCH --error=out/_P5-4_%J_stderr.txt
#
#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0
source "$ONEAPI/setvars.sh"

# Compile the code
make -C Problem_4 clean && make -C Problem_4

echo "--- Starting runs ---"

# (Project_5_Instructions.pdf, Page 11)
# n = 2^16 (fixed). Processors: 2, 4, 8, 16.

srun -n 2 ./Problem_4/pi_MPI Problem_4/result_2p_prob4.csv Problem_4/time_2p_prob4.csv
srun -n 4 ./Problem_4/pi_MPI Problem_4/result_4p_prob4.csv Problem_4/time_4p_prob4.csv
srun -n 8 ./Problem_4/pi_MPI Problem_4/result_8p_prob4.csv Problem_4/time_8p_prob4.csv
srun -n 16 ./Problem_4/pi_MPI Problem_4/result_16p_prob4.csv Problem_4/time_16p_prob4.csv
