# Phase 1 Context: Problem 2 (Average TF)

## Decisions and Constraints

### CLI Arguments
- **Number of Arguments:** 5 total (`input_file`, `output_file`, `time_file`, `num_threads`).
- **Consistency:** All Phase 1 binaries will follow this 5-argument structure.
- **Error Handling:** If the argument count is not exactly 5, the program will print a usage message and terminate with an error code.
- **Thread Count:** The 4th argument must be a valid integer; there is no fallback to environment variables.

### Output Formatting
- **average_TF.csv:** One frequency per line, formatted with `%.6f` precision.
- **time.csv:** Raw numeric seconds only (e.g., `1.234567`), no labels.
- **Console:** The program will be silent during execution. No "Processing..." or thread-ID messages.

### Error Handling (Area 4)
- **Missing Header:** If a gene sequence is not preceded by a `>` header, the program will terminate with an error.
- **Non-ACGT Characters:** If any character other than 'A', 'C', 'G', or 'T' is encountered, the program will terminate with an error.
- **Memory Allocation:** If `malloc` fails, the program will print a descriptive error message and terminate.
- **Short Sequences:** If a gene sequence is shorter than 4 characters, the program will terminate with an error.

### Implementation Specifics
- **Exp1 Variants:** `critical.c`, `atomic.c`, `locks.c` will each implement a specific mutual exclusion method for updating the global `TF` array.
- **Exp2 Variant:** `schedule.c` will use `#pragma omp parallel for schedule(runtime)` to allow external scheduling configuration.
- **Modular Logic:** Logic will be split into readable functions like `process_tetranucs` and `aggregate_results`.

## Deferred Ideas
- *None at this time.*
