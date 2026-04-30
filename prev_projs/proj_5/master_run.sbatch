#!/bin/bash
#SBATCH --partition=oucspdn_cpu
#SBATCH --ntasks=16
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:30:00
#SBATCH --job-name=Master_Project_5
#SBATCH --output=out/master_P5_%J_stdout.txt
#SBATCH --error=out/master_P5_%J_stderr.txt
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL

echo "--- Comprehensive Master Execution Script for Project 5 ---"
date
echo "Working directory: $(pwd)"
echo ""

# Load required modules
module load OpenMPI/4.1.4-GCC-11.3.0
module load python/3.10.8-GCCcore-12.2.0

# Create output directory
mkdir -p out

echo "--- Phase 1: Compiling all problems ---"
make -C Problem_1 clean && make -C Problem_1
make -C Problem_2 clean && make -C Problem_2
make -C Problem_3 clean && make -C Problem_3
make -C Problem_4 clean && make -C Problem_4
echo ""

echo "--- Phase 2: Running Benchmarks ---"

echo "Problem 1: Ping-Pong (Same Node & Different Nodes)"
for size in 1000000 2000000 4000000 8000000; do
    sname=$(echo $size | sed 's/000000/M/')
    mpirun -n 2 --map-by core ./Problem_1/pingpong_MPI $size Problem_1/time_${sname}_same.csv
    mpirun -n 2 --map-by node ./Problem_1/pingpong_MPI $size Problem_1/time_${sname}_diff.csv
done

echo "Problem 2: Dot Product (Full Suite)"
for size in 262144 524288 1048576; do
    pname=$(echo "2^18 2^19 2^20" | cut -d' ' -f$(echo "262144 524288 1048576" | tr ' ' '\n' | grep -n $size | cut -d: -f1))
    for p in 2 4 8; do
        mpirun -n $p ./Problem_2/dot_product_MPI $size tests/Project_5_Tests/test_data/Vectors/vec1_${pname}.csv tests/Project_5_Tests/test_data/Vectors/vec2_${pname}.csv Problem_2/result_${p}p_${pname:2}.csv Problem_2/time_${p}p_${pname:2}.csv
    done
done

echo "Problem 3: Merge Sort (Including Same vs Diff Node comparison)"
for size in 262144 524288 1048576; do
    pname=$(echo "2^18 2^19 2^20" | cut -d' ' -f$(echo "262144 524288 1048576" | tr ' ' '\n' | grep -n $size | cut -d: -f1))
    # 4 processes same node
    mpirun -n 4 --map-by ppr:4:node ./Problem_3/merge_sort_MPI $size tests/Project_5_Tests/test_data/Vectors/vec1_${pname}.csv Problem_3/result_4p_${pname:2}_same.csv Problem_3/time_4p_${pname:2}_same.csv
    # 4 processes different nodes (1 per node)
    mpirun -n 4 --map-by ppr:1:node ./Problem_3/merge_sort_MPI $size tests/Project_5_Tests/test_data/Vectors/vec1_${pname}.csv Problem_3/result_4p_${pname:2}_diff.csv Problem_3/time_4p_${pname:2}_diff.csv
done

echo "Problem 4: Monte Carlo Pi (Up to 16 Processes)"
for p in 2 4 8 16; do
    mpirun -n $p ./Problem_4/pi_MPI Problem_4/result_${p}p.csv Problem_4/time_${p}p.csv
done

echo ""
echo "--- Phase 3: Running Autograder ---"
if [ -d "venv" ]; then
    source venv/bin/activate
    python tests/Project_5_Tests/Autograder/autograder_project_5.py
    deactivate
else
    python3 tests/Project_5_Tests/Autograder/autograder_project_5.py
fi

echo ""
echo "--- Master Execution Finished ---"
date
