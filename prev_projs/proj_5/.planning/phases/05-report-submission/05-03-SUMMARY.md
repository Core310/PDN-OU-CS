---
phase: 05-report-submission
plan: 03
summary: true
---

## Summary of Work (Plan 03)

### Objective
Assembled the final report document, including all analysis and discussions, and created the complete submission package.

### Key Changes
- **`reports/REPORT.md`**:
    - Drafted a comprehensive final report in Markdown format.
    - Included sections for Introduction, Problem 1 (Ping-Pong Communication), Problem 2 (Parallel Dot Product), Problem 3 (Parallel Merge Sort), Problem 4 (Monte Carlo Pi Estimation), and Conclusion.
    - Embedded generated plots (`reports/problem1_plot_diffnode.png`, `reports/problem1_plot_samenode.png`) and incorporated content from the Markdown summary tables (`reports/problem2_summary_table.md`, `reports/problem3_summary_table.md`, `reports/problem4_summary_table.md`).
    - Provided discussion on methodology, results, scalability, and communication costs for each problem.
- **`reports/REPORT.pdf`**:
    - Attempted to convert `reports/REPORT.md` to PDF using `pandoc`. This step was ultimately **skipped** as the necessary `pdflatex` (LaTeX distribution) was not available in the environment, and the user indicated PDF generation was not strictly required.
- **`submission.zip`**:
    - Created a final `submission.zip` archive in the project root.
    - The archive was carefully constructed to include:
        - All source code (`Problem_1/`, `Problem_2/`, `Problem_3/`, `Problem_4/`).
        - All `Makefile`s and `.sbatch` scripts within these directories.
        - The entire `reports/` directory (containing `REPORT.md`, analysis scripts, generated plots, and summary tables).
        - Project-level documentation (`README.md`, `CODING_GUIDELINES.md`).
    - Excluded temporary build files (executables, `.o` files) and the `.planning/` directory as per project guidelines.

### Verification
- **`reports/REPORT.md`**: Confirmed existence and content structure.
- **`reports/REPORT.pdf`**: Verification for this step was skipped as the PDF generation was not feasible.
- **`submission.zip`**: Confirmed existence and inspected contents using `unzip -l submission.zip` to ensure all required files were included and extraneous files were excluded.

### Outcome
The final report in Markdown format is complete and available (`reports/REPORT.md`). The `submission.zip` archive has been successfully created with all required project deliverables, making the project ready for submission.
