#!/bin/bash
#SBATCH --job-name=simple_run_test
#SBATCH --ntasks=1
#SBATCH --time=00:01:00
#SBATCH --output=out/simple_run_test_%J.log
#SBATCH --error=out/simple_run_test_%J.err

echo "--- Starting Simple Run Test ---"
echo "Current working directory (pwd) is:"
pwd
echo ""

module load OpenMPI/4.1.4-GCC-11.3.0

echo "--- Running make for Problem 2 ---"
make -C Problem_2 clean && make -C Problem_2
echo "--- Make finished. Exit status: $? ---"
echo ""

echo "--- Running srun command for Problem 2 (minimal) ---"
# Only run one srun command, redirecting program output to /dev/null
srun -n 1 ./Problem_2/dot_product_MPI 262144 tests/Project_5_Tests/test_data/Vectors/vec1_2^18.csv tests/Project_5_Tests/test_data/Vectors/vec2_2^18.csv /dev/null /dev/null
echo "--- srun finished. Exit status: $? ---"
echo ""
echo "--- Simple Run Test Complete ---"