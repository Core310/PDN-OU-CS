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
#SBATCH --chdir=/home/oucspdn089/git/PDN-OU-CS/proj_5/Problem_2
#SBATCH --output=/home/oucspdn089/git/PDN-OU-CS/proj_5/out/_P5-2_%J_stdout.txt
#SBATCH --error=/home/oucspdn089/git/PDN-OU-CS/proj_5/out/_P5-2_%J_stderr.txt
#
#################################################

echo "Working directory:"
pwd
echo ""

module load intel/2022.2
module load OpenMPI/4.1.4-GCC-11.3.0

# (Project_5_Instructions.pdf, Page 6)
# Processes: 2, 4, 8. Sizes: 262144, 524288, 1048576.
# Vectors are in ../test_data/Vectors/ (assuming relative path as per structure)

mpirun -n 2 ./dot_product_MPI 262144 vec_2_18_1.csv vec_2_18_2.csv res_2p_18.csv time_2p_18.csv
mpirun -n 4 ./dot_product_MPI 262144 vec_2_18_1.csv vec_2_18_2.csv res_4p_18.csv time_4p_18.csv
mpirun -n 8 ./dot_product_MPI 262144 vec_2_18_1.csv vec_2_18_2.csv res_8p_18.csv time_8p_18.csv

mpirun -n 2 ./dot_product_MPI 524288 vec_2_19_1.csv vec_2_19_2.csv res_2p_19.csv time_2p_19.csv
mpirun -n 4 ./dot_product_MPI 524288 vec_2_19_1.csv vec_2_19_2.csv res_4p_19.csv time_4p_19.csv
mpirun -n 8 ./dot_product_MPI 524288 vec_2_19_1.csv vec_2_19_2.csv res_8p_19.csv time_8p_19.csv

mpirun -n 2 ./dot_product_MPI 1048576 vec_2_20_1.csv vec_2_20_2.csv res_2p_20.csv time_2p_20.csv
mpirun -n 4 ./dot_product_MPI 1048576 vec_2_20_1.csv vec_2_20_2.csv res_4p_20.csv time_4p_20.csv
mpirun -n 8 ./dot_product_MPI 1048576 vec_2_20_1.csv vec_2_20_2.csv res_8p_20.csv time_8p_20.csv
