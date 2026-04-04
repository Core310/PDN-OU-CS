# AI Usage
DISCLAIMER: As with all AI tools, I understand that they are good for generating *templates* **not** for actual code. Overly relying on AI generated code quickly leads to immense tech debt and what many people call "vibe coding clean-up" roles. Most of what was used was either a) proof of concept to see how well the tools fair with heavy user influence, or b) to check exisitng work currently written as a "helper" to optmize performance and readability.

While documentation was tidied and used to generate suggestions with the Gemini CLI workflow, most of it still ended up handwritten.

The primary use of AI in this project was through the Gemini CLI, leveraging its integrated GSD (Get Shit Done) workflow for project planning, execution, and verification.

## Gemini CLI & GSD Workflow

The Gemini CLI, powered by the `gsd-opencode` model, was instrumental in structuring and automating various aspects of this MPI project. It provided a framework for breaking down complex tasks, tracking progress, and interactively developing solutions.

### Role of Agents and Skills
Within the Gemini CLI, tasks are handled by a system of agents and skills. Gemini itself acts as an orchestrating agent, delegating specific parts of a task to specialized sub-agents. Skills, on the other hand, represent activated domains of expertise or specific workflows that provide procedural guidance and tools for the duration of a task.

In the context of this project:
-   **Agents**: I, as the interactive CLI agent, delegated tasks to various internal capabilities. For instance, the GSD workflow is managed by several `gsd-*` sub-agents (e.g., `gsd_planner`, `gsd_executor` (which is often the orchestrating agent itself when directly performing file modifications or running commands), `gsd_assumptions_analyzer`). When you asked for code modifications or file operations, I utilized my core mandates and available tools (`read_file`, `replace`, `run_shell_command`) acting as the primary agent responsible for executing those tasks.
-   **Skills**: While no explicit skills were "activated" by name during this specific project interaction (other than my core mandates), the GSD workflow itself can be thought of as a complex skill providing a structured approach. The specialized instructions given at the start of the session (e.g., project mandates in `GEMINI.md`) effectively function as a custom skill, guiding my behavior and priorities throughout the project. The ability to use tools like `write_todos` is a capability provided by my underlying agent framework.

### Initialization (`/gsd-new-project`)
This phase involved setting up the project's foundational structure and understanding initial requirements.
- **Initial Questions**: Gemini facilitated clarifying project scope, constraints (e.g., Slurm environment, MPI limitations), and specific requirements for each problem.
- **PDF Document Upload**: The `Project_5_Instructions.pdf` was analyzed by Gemini, allowing for direct extraction and interpretation of problem specifications, grading rubrics, and submission guidelines.
- **Assumptions**: GSD helped identify and document implicit assumptions (e.g., specific OpenMPI module versions, `mpirun` vs. `srun` on Schooner due to PMI issues).
- **Codebase Linking**: The local repository was linked, enabling Gemini to read and modify files directly.
- **README Generation**: Initial `README.md` and planning documents were generated to outline the project's roadmap and state.

### Research
Although a dedicated `Research` phase was not explicitly triggered, elements of research were integrated into other phases. Gemini, when faced with environmental complexities (e.g., `srun` limitations, module conflicts), effectively researched solutions by suggesting diagnostic scripts and analyzing their outputs.

### Planning (`/gsd-plan-phase <number>`)
GSD's planning capabilities were used to break down the project into manageable phases and atomic tasks.
- **Phase Definition**: Each of the four MPI problems (Ping-Pong, Dot Product, Merge Sort, Monte Carlo Pi) was defined as a distinct phase. Reporting and submission were also planned as separate phases.
- **Task Breakdown**: For each phase, detailed plans (`0X-XX-PLAN.md`) were generated, outlining specific implementation steps, file modifications, and success criteria.
- **Plan Checker**: This ensured that all aspects of a problem were addressed before proceeding to execution.
- **Context Isolation**: Gemini maintained context specific to each phase, allowing focused development.

### Execution (`/gsd-run-phase <number>`)
The core development work was performed during the execution phases, with Gemini acting as the primary agent for code generation and modification.
- **Iterative Implementation**: Gemini implemented the C code for each MPI problem (`dot_product_MPI.c`, `merge_sort_MPI.c`, `pi_MPI.c`) and configured associated `Makefile`s and `.sbatch` scripts.
- **Debugging & Refinement**: This phase involved extensive interactive debugging, particularly for cluster-specific issues. Gemini iteratively identified and fixed:
    - `sbatch` script errors (e.g., incorrect module loading, `srun` vs. `mpirun`, resource directives).
    - Python virtual environment setup and dependency installation.
    - Autograder script bugs (e.g., pathing errors, `KeyError` in `pandas`).
    - C code errors (e.g., `fopen` NULL checks, `cmpfloat` function corruption leading to segfaults and compiler errors).
- **Automation**: Creation of utility scripts like `run_all_sbatch.sh` and `run_autograder.sh` was managed during execution.

### Verification
Verification was a continuous and critical process, often driving subsequent execution and debugging cycles.
- **Autograder Runs**: Gemini facilitated repeated execution of the Python autograder to validate the correctness and performance of each MPI implementation.
- **Error Analysis**: When autograder tests failed, Gemini analyzed the output, pinpointed root causes (e.g., compiler errors, runtime segfaults, incorrect output), and proposed fixes.
- **Documentation Updates**: This involved updating `README.md`, `.planning/STATE.md`, and phase summary documents to accurately reflect project status, completed tasks, and key changes.

The interactive nature of the Gemini CLI with the GSD workflow allowed for a structured, iterative approach to problem-solving, enabling rapid identification and resolution of issues encountered during the implementation and testing of the parallel MPI algorithms.
