#!/bin/bash

# This script submits all sbatch jobs for Project 5.
# It must be run from the project root directory on a Slurm-enabled system.

echo "--- Submitting all sbatch jobs for Project 5 ---"
echo ""

# Problem 1
if [ -f "Problem_1/pingpong_samenode.sbatch" ]; then
    echo "Submitting jobs for Problem 1: Ping-Pong..."
    sbatch Problem_1/pingpong_samenode.sbatch
    sbatch Problem_1/pingpong_diffnode.sbatch
    echo ""
else
    echo "Warning: Problem_1 sbatch files not found."
fi

# Problem 2
if [ -f "Problem_2/dot_product.sbatch" ]; then
    echo "Submitting job for Problem 2: Dot Product..."
    sbatch Problem_2/dot_product.sbatch
    echo ""
else
    echo "Warning: Problem_2 sbatch file not found."
fi

# Problem 3
if [ -f "Problem_3/merge_sort_samenode.sbatch" ]; then
    echo "Submitting jobs for Problem 3: Merge Sort..."
    sbatch Problem_3/merge_sort_samenode.sbatch
    sbatch Problem_3/merge_sort_diffnode.sbatch
    echo ""
else
    echo "Warning: Problem_3 sbatch files not found."
fi

# Problem 4
if [ -f "Problem_4/pi.sbatch" ]; then
    echo "Submitting job for Problem 4: Monte Carlo Pi..."
    sbatch Problem_4/pi.sbatch
    echo ""
else
    echo "Warning: Problem_4 sbatch file not found."
fi

echo "--- All jobs submitted. ---"
echo "Use 'squeue -u \$USER' to check the status of your jobs."
