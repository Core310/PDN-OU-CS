#!/bin/bash
#SBATCH --job-name=compile_test
#SBATCH --ntasks=1
#SBATCH --time=00:02:00
#SBATCH --output=out/compile_test_%j.log
#SBATCH --error=out/compile_test_%j.err

echo "--- Starting Compile Test ---"
echo ""
echo "Job running on node: $(hostname)"
echo ""
echo "Current working directory (pwd) is:"
pwd
echo ""
echo "--- Running make for Problem 2 ---"
make -C Problem_2 clean
make -C Problem_2
echo "--- Make finished. Exit status: $? ---"
echo ""
echo "Listing contents of Problem_2 directory:"
ls -l Problem_2
echo ""
echo "--- Compile Test Complete ---"
