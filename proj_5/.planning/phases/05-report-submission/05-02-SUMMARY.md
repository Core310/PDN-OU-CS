---
phase: 05-report-submission
plan: 02
summary: true
---

## Summary of Work (Plan 02)

### Objective
Successfully generated all required performance metrics, tables, and plots for the final report. This involved creating dedicated Python scripts for analysis and ensuring their correct execution.

### Key Changes
- **`reports/problem1_analysis.py`**:
    - Created a Python script to perform detailed analysis for Problem 1 (Ping-Pong Communication).
    - Loaded timing data for both same-node and different-node communication.
    - Implemented plotting of array size vs. one-way transmission time.
    - Performed linear regression to estimate latency (intercept) and bandwidth (inverse of slope).
    - Generated and saved two PNG plots: `reports/problem1_plot_diffnode.png` and `reports/problem1_plot_samenode.png`.
    - Printed estimated latency and bandwidth values to standard output.
- **`reports/problem_summary_tables.py`**:
    - Created a Python script to generate summary tables for Problems 2, 3, and 4.
    - Loaded `problem2_times.csv`, `problem3_times.csv`, and `problem4_times.csv`.
    - Utilized `calculate_speedup` and `calculate_efficiency` functions from `reports/analysis_utils.py`.
    - Formatted wall-clock times, speedup, and efficiency metrics into Markdown tables.
    - Saved each table to a separate Markdown file: `reports/problem2_summary_table.md`, `reports/problem3_summary_table.md`, and `reports/problem4_summary_table.md`.

### Verification
- **Execution**: Both `reports/problem1_analysis.py` and `reports/problem_summary_tables.py` were successfully executed.
- **Artifacts**: Confirmed the generation of two PNG plots (`problem1_plot_diffnode.png`, `problem1_plot_samenode.png`) and three Markdown summary tables (`problem2_summary_table.md`, `problem3_summary_table.md`, `problem4_summary_table.md`) in the `reports/` directory.
- **Content**: Visually inspected the generated plots and tables to ensure they contained reasonable performance metrics and data visualizations.

### Outcome
This plan successfully produced all necessary analytical outputs, including plots and summary tables, which form the core data-driven content for the final project report.
