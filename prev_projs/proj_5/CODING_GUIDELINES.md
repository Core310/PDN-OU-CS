# Coding Guidelines: Project 5 (MPI Programming)

## Mandates (Derived from Project 3 & Updated for Project 5)

### Minimalist Commenting
- **No Single-Line Comments:** Use zero single-line comments (`//`).
- **No Redundancy:** Delete all redundant or self-explanatory comments.

### Documentation
- **Section Headers:** Use multi-line block comments (`/* ... */`) only for major logical sections, parallel strategies, and requirements.
- **Traceability:** Logic derived from project instructions MUST include a multi-line block comment quoting the exact wording and page number from `Project_5_Instructions.pdf`.

### Code Style
- **Modularity:** Keep parallel algorithm logic clean and focused. Shared logic (if any) should be in a `setup/` module.
- **CLI/IO:** Enforce strict CLI argument counts as specified for each problem.
- **Precision:** Time measurements and other frequency outputs must use `%.6f` precision.

### Example Block Comment Style:
```c
/*
 * Parallel Strategy:
 * 1. Process 0 reads the entire array from the input file.
 * 2. Scatter the array to all processes using MPI_Scatter.
 * 3. Each process sorts its local part using qsort.
 * (Project_5_Instructions.pdf, Page 7)
 */
```

### Constraints Checklist:
- [ ] No `//` comments.
- [ ] Multi-line block comments for sections.
- [ ] Instruction quotes with page numbers.
- [ ] Correct CLI argument handling.
- [ ] `%.6f` precision for times.
