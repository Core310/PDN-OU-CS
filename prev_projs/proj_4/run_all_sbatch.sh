#!/bin/bash

# This script submits the sbatch jobs for Problems 1, 2, and 3.

# Navigate to the Problem 1 directory and submit the job
echo "Submitting job for Problem 1..."
cd Khor_Arika_Project_4/Problem_1
sbatch P4-1.sbatch
cd ../.. # Go back to the proj_4 directory

# Navigate to the Problem 2 directory and submit the job
echo "Submitting job for Problem 2..."
cd Khor_Arika_Project_4/Problem_2
sbatch P4-2.sbatch
cd ../.. # Go back to the proj_4 directory

# Navigate to the Problem 3 directory and submit the job
echo "Submitting job for Problem 3..."
cd Khor_Arika_Project_4/Problem_3
sbatch P4-3.sbatch
cd ../.. # Go back to the proj_4 directory

echo "
All jobs submitted. Use 'squeue -u oucspdn089' to check their status."
