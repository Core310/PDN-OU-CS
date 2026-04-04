#!/bin/bash

# This script runs the Python autograder for Project 5.
# It must be run from the project root directory.

echo "--- Running Project 5 Autograder ---"

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "Error: Python virtual environment 'venv' not found."
    echo "Please create and install dependencies (e.g., 'python3 -m venv venv && source venv/bin/activate && pip install pandas matplotlib numpy')."
    exit 1
fi

# Activate the virtual environment
source venv/bin/activate

# Run the main autograder script
python tests/Project_5_Tests/Autograder/autograder_project_5.py

# Deactivate the virtual environment (optional, but good practice)
deactivate

echo "--- Autograder finished ---"
