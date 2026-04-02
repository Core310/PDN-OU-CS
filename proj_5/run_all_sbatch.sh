#!/bin/bash

# This script submits all sbatch jobs for Project 5.
# It must be run from the project root directory on a Slurm-enabled system.

echo "--- Submitting all sbatch jobs for Project 5 ---"
echo ""

# Problem 1
if [ -d "Problem_1" ]; then
    echo "Submitting jobs for Problem 1: Ping-Pong..."
    (cd Problem_1 && sbatch pingpong_samenode.sbatch)
    (cd Problem_1 && sbatch pingpong_diffnode.sbatch)
    echo ""
else
    echo "Warning: Problem_1 directory not found."
fi

# Problem 2
if [ -d "Problem_2" ]; then
    echo "Submitting job for Problem 2: Dot Product..."
    (cd Problem_2 && sbatch dot_product.sbatch)
    echo ""
else
    echo "Warning: Problem_2 directory not found."
fi

# Problem 3
if [ -d "Problem_3" ]; then
    echo "Submitting jobs for Problem 3: Merge Sort..."
    (cd Problem_3 && sbatch merge_sort_samenode.sbatch)
    (cd Problem_3 && sbatch merge_sort_diffnode.sbatch)
    echo ""
else
    echo "Warning: Problem_3 directory not found."
fi

# Problem 4
if [ -d "Problem_4" ]; then
    echo "Submitting job for Problem 4: Monte Carlo Pi..."
    (cd Problem_4 && sbatch pi.sbatch)
    echo ""
else
    echo "Warning: Problem_4 directory not found."
fi

echo "--- All jobs submitted. ---"
echo "Use 'squeue -u \$USER' to check the status of your jobs."
