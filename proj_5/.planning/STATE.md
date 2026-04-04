# State Tracker: Project 5 (MPI Programming)

## Milestone Status
- [x] Milestone 1: Problem 1 - Ping-Pong
- [x] Milestone 2: Problem 2 - Parallel Dot Product
- [x] Milestone 3: Problem 3 - Parallel Merge Sort
- [x] Milestone 4: Problem 4 - Monte Carlo Pi (Graduate)
- [x] Milestone 5: Final Report & Submission

## Completed Tasks
### Phase 1: Planning & Setup
- [x] Create `.planning/PROJECT.md`
- [x] Create `.planning/config.json`
- [x] Create `.planning/REQUIREMENTS.md`
- [x] Create `.planning/ROADMAP.md`
- [x] Create `.planning/STATE.md`
- [x] Create `CODING_GUIDELINES.md`

### Phase 2: File Layout & Structure
- [x] Generate `.planning/STRUCTURE.md`
- [x] Create placeholder files for Problem 2 and Problem 4.

### Phase 3: Configuration for Supercomputer (Schooner)
- [x] Update all `.sbatch` files with user email, paths, and tasks.

### Phase 4: Problem 2 - Parallel Dot Product
- [x] Implement parallel dot product in `Problem_2/dot_product_MPI.c`.
- [x] Verify implementation with autograder.

### Phase 5: Problem 3 - Parallel Merge Sort
- [x] Implement parallel merge sort in `Problem_3/merge_sort_MPI.c`.
- [x] Verify implementation with autograder.

### Phase 6: Problem 4 - Monte Carlo Pi
- [x] Implement Monte Carlo Pi estimation in `Problem_4/pi_MPI.c`.
- [x] Configure Makefile and sbatch script for Problem 4.

### Phase 7: Problem 1 - Ping-Pong Communication
- [x] Implement ping-pong communication in `Problem_1/pingpong_MPI.c`.
- [x] Configure Makefile and sbatch scripts for Problem 1.

### Phase 8: Reporting, Analysis & Submission
- [x] Set up Python virtual environment with `pandas`, `matplotlib`, `numpy`.
- [x] Create `run_autograder.sh` script.
- [x] Fix autograder pathing bugs (`autograder_problem_5_2.py`, `autograder_problem_5_3.py`, `autograder_problem_5_4.py`).
- [x] Fix C code bugs (e.g., Problem 3 `fopen` null check, `cmpfloat` corruption).
- [x] Run all sbatch jobs via `run_all_sbatch.sh` to generate raw timing data.
- [x] Run autograder via `run_autograder.sh` to generate grades and analysis CSVs.
- [x] Generate performance metrics, tables, and plots.
- [x] Draft the Final Report in Markdown (`reports/REPORT.md`).
- [x] Create Final Submission ZIP Archive (`submission.zip`) with specified content.

## Active Tasks
- None. All project tasks completed.
