#!/bin/bash

# User-specific details
EMAIL="arikak@ou.edu"
USERNAME="oucspdn089"
PROJ_DIR="/home/oucspdn089/git/PDN-OU-CS/proj_4"
CH_DIR="$PROJ_DIR/Khor_Arika_Project_4"
OUT_DIR="$PROJ_DIR/out"

# Create the output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# --- Update Problem 1 sbatch file ---
P1_SBATCH_FILE="$CH_DIR/Problem_1/P4-1.sbatch"
sed -i "s|yourEmailHere@ou.edu|$EMAIL|" "$P1_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_1|$CH_DIR/Problem_1|" "$P1_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_1/_P4-1_%J_stdout.txt|$OUT_DIR/_P4-1_%J_stdout.txt|" "$P1_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_1/_P4-1_%J_stderr.txt|$OUT_DIR/_P4-1_%J_stderr.txt|" "$P1_SBATCH_FILE"
echo "Updated $P1_SBATCH_FILE"

# --- Update Problem 2 sbatch file ---
P2_SBATCH_FILE="$CH_DIR/Problem_2/P4-2.sbatch"
sed -i "s|yourEmailHere@ou.edu|$EMAIL|" "$P2_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_2|$CH_DIR/Problem_2|" "$P2_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_2/_P4-2_%J_stdout.txt|$OUT_DIR/_P4-2_%J_stdout.txt|" "$P2_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_2/_P4-2_%J_stderr.txt|$OUT_DIR/_P4-2_%J_stderr.txt|" "$P2_SBATCH_FILE"
echo "Updated $P2_SBATCH_FILE"

# --- Update Problem 3 sbatch file ---
P3_SBATCH_FILE="$CH_DIR/Problem_3/P4-3.sbatch"
sed -i "s|yourEmailHere@ou.edu|$EMAIL|" "$P3_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_3|$CH_DIR/Problem_3|" "$P3_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_3/_P4-3_%J_stdout.txt|$OUT_DIR/_P4-3_%J_stdout.txt|" "$P3_SBATCH_FILE"
sed -i "s|/home/oucspdnxxx/ ... /Project_4/Problem_3/_P4-3_%J_stderr.txt|$OUT_DIR/_P4-3_%J_stderr.txt|" "$P3_SBATCH_FILE"
echo "Updated $P3_SBATCH_FILE"

echo "
All sbatch files have been updated."
echo "You can now navigate to each Problem directory and run 'sbatch <sbatch_file_name>'"
