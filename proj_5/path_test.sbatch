#!/bin/bash
#SBATCH --job-name=path_test
#SBATCH --ntasks=1
#SBATCH --time=00:01:00
#SBATCH --output=out/path_test_%j.log
#SBATCH --error=out/path_test_%j.err

echo "--- Starting Path Test ---"
echo ""
echo "Job running on node: $(hostname)"
echo ""
echo "SLURM_SUBMIT_DIR is: $SLURM_SUBMIT_DIR"
echo ""
echo "Current working directory (pwd) is:"
pwd
echo ""
echo "--- Test Complete ---"
