#!/bin/bash
# Choose the partition that you will use.
# You can choose: oucspdn_cpu OR debug_5min OR debug OR others 
#
#SBATCH --partition=oucspdn_cpu
#
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=8
#
#SBATCH --time=00:30:00
#SBATCH --job-name=auto
#
#
# --------------------- Change the items below here! ---------------------
#
#SBATCH --mail-user=arikak@ou.edu
#SBATCH --mail-type=ALL
#
#SBATCH --chdir=/home/oucspdn089/git/PDN-OU-CS/Project_3_Problems/
#SBATCH --output=/home/oucspdn089/git/PDN-OU-CS/Project_3_Problems/out/autograding_%J_stdout.txt
#SBATCH --error=/home/oucspdn089/git/PDN-OU-CS/Project_3_Problems/out/autograding_%J_stderr.txt

#################################################

source /home/oucspdnta/activate_pdn_env.sh

echo "--- Debug: Environment Check ---"
echo "Current Directory: $(pwd)"
echo "Listing files in Project_3_Problems:"
ls -F ..
echo "Listing files in Khor_Arika_Project_3:"
ls -F .

# Build all binaries from scratch on the compute node
make -C .. clean && make -C .. all

# Move into the specific problem directory
cd Khor_Arika_Project_3

export PYTHONPATH=$PYTHONPATH:$(pwd)/..

echo "--- Debug: Python Import Test ---"
python3 -c "import sys; sys.path.append('..'); import autograder_base; print('autograder_base imported successfully')"

echo "--- Debug: Running Autograder ---"
# Use -u for unbuffered output to ensure we see prints immediately
python3 -u autograder_project_3.py 2>&1

# To run just problem 2's autograder
#python3 -u autograder_problem_3_2.py

# To run just problem 3's autograder
# python3 -u autograder_problem_3_3.py

# To run just problem 4's autograder
# python3 -u autograder_problem_3_4.py