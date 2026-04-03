#!/bin/bash
#SBATCH --job-name=make_test
#SBATCH --ntasks=1
#SBATCH --time=00:02:00
#SBATCH --output=out/make_test_%J.log
#SBATCH --error=out/make_test_%J.err

echo "--- Starting Make Test ---"
echo "Current working directory: $(pwd)"

module load OpenMPI/4.1.4-GCC-11.3.0
echo "Module loaded."

echo "Running make -C Problem_2 clean..."
make -C Problem_2 clean
echo "Exit status for clean: $?"

echo "Running make -C Problem_2..."
make -C Problem_2
echo "Exit status for make: $?"
echo "--- Test Complete ---"
