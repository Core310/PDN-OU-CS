# Project Mandates: Project 3

This file contains foundational mandates for the Gemini CLI agent. These instructions take absolute precedence over general workflows.

## Communication Workflow
1.  **Pre-Phase Discussion:** Before starting any coding in a phase, the agent MUST discuss the implementation plan with the user.
2.  **README Updates:** Upon agreement of the plan, the agent MUST update `README.md` with the detailed coding steps for that phase.
3.  **Post-Phase Discussion:** After a phase is completed, the agent MUST discuss the specific changes made with the user.
4.  **Sequencing:** The agent must finish the Post-Phase discussion and start the next Pre-Phase discussion before moving to new tasks.

## Coding & Commenting Standards
- **Minimalism:** Use zero single-line comments (`//`). Delete all redundant self-explanatory comments.
- **Documentation:** Use multi-line block comments (`/* ... */`) only for logical sections, parallel strategies, and requirements.
- **Traceability:** Logic derived from project instructions MUST include a comment quoting the exact wording and page number from `Project_3_Instructions.pdf`.
- **Modularity:** Maintain the `setup/` module for all shared logic. Problem files must focus strictly on the parallel algorithm logic.
- **CLI/IO:** Enforce strict 5-arg CLI for TF problems and 7-arg for K-means. Frequencies must use `%.6f` precision.
