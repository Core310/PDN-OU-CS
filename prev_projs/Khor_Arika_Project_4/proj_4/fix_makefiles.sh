#!/bin/bash

# This script fixes the Makefiles for Problems 1, 2, and 3.

# --- Fix Problem 1 Makefile ---
P1_MAKEFILE="Khor_Arika_Project_4/Problem_1/Makefile"
# Correct the FILE path
sed -i 's|FILE     = debug_1k.csv|FILE     = ../../test_data/Problem_1_and_2/debug_1k.csv|' "$P1_MAKEFILE"
# Correct the run target
sed -i '/^run:/,/^$/c
run:
	./gpu_mining_starter $(FILE) $(SIZE) $(TRIALS_A) _out_$(OUT_A).csv _time_$(OUT_A).csv
	./gpu_mining_starter $(FILE) $(SIZE) $(TRIALS_B) _out_$(OUT_B).csv _time_$(OUT_B).csv
' "$P1_MAKEFILE"
echo "Fixed $P1_MAKEFILE"


# --- Fix Problem 2 Makefile ---
P2_MAKEFILE="Khor_Arika_Project_4/Problem_2/Makefile"
cp "$P1_MAKEFILE" "$P2_MAKEFILE"
sed -i 's/gpu_mining_starter/gpu_mining_problem2/g' "$P2_MAKEFILE"
echo "Fixed $P2_MAKEFILE"

# --- Fix Problem 3 Makefile ---
P3_MAKEFILE="Khor_Arika_Project_4/Problem_3/Makefile"
cp "$P1_MAKEFILE" "$P3_MAKEFILE" # Start from a known good state
# For problem 3, the file is mat_input.csv
sed -i 's|FILE     = ../../test_data/Problem_1_and_2/debug_1k.csv|FILE     = ../../test_data/Problem_3/mat_input.csv|' "$P3_MAKEFILE"
# And the executable is convolution_CUDA
sed -i 's/gpu_mining_starter/convolution_CUDA/g' "$P3_MAKEFILE"
# And the arguments are different
sed -i '/^run:/,/^$/c
run:
	./convolution_CUDA 2048 2048 $(FILE) results.csv time.csv
' "$P3_MAKEFILE"
echo "Fixed $P3_MAKEFILE"

echo ""
echo "All Makefiles have been updated."
echo "You can now re-run the sbatch submission script."
