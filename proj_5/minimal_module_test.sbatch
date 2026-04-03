#!/bin/bash
#SBATCH --job-name=min_mod_test
#SBATCH --ntasks=1
#SBATCH --time=00:01:00
#SBATCH --output=out/min_mod_test_%J.log
#SBATCH --error=out/min_mod_test_%J.err

echo "--- Starting Minimal Module Test ---"
echo "Current working directory: $(pwd)"
echo "Loading OpenMPI module..."
module load OpenMPI/4.1.4-GCC-11.3.0
echo "OpenMPI module loaded successfully."
echo "--- Test Complete ---"
