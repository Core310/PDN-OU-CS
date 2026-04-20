# Codebase Concerns

**Analysis Date:** 2024-07-25

## Tech Debt

**Incomplete GPU Implementation:**
- **Issue:** Core logic for the mining application is currently implemented on the CPU as a placeholder, with `TODO` markers indicating where GPU implementation is required. This is not technical debt from a production shortcut, but rather represents the primary unimplemented features of the project.
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`, `Khor_Arika_Project_4/Problem_1/hash_kernel.cu`
- **Impact:** The application does not leverage the GPU for its main computational tasks (hashing and reduction), failing to meet the project's performance goals.
- **Fix approach:** Implement the CUDA kernels for hash generation and parallel reduction to find the minimum hash value, replacing the current serial `for` loops.
  - `gpu_mining_starter.cu:105`: `// TODO Problem 1: perform this hash generation in the GPU`
  - `gpu_mining_starter.cu:116`: `// TODO Problem 2: find the minimum in the GPU by reduction`
  - `hash_kernel.cu:4`: `// TODO: Generate hash values`

## Fragile Areas

**Fixed-Size Buffer in File Reading:**
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`
- **Why fragile:** The `read_file` function uses a fixed-size stack buffer (`char line[100]`) to read lines from the transaction file. A line longer than 99 characters will cause a buffer overflow, leading to undefined behavior or a crash.
- **Safe modification:** Use a dynamically allocated buffer or `getline()` if available. At a minimum, use `fgets` with a size limit that is strictly enforced and check for read errors or truncation.
- **Test coverage:** It is unlikely that the existing tests cover this edge case.

**Basic Command-Line Argument Parsing:**
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`
- **Why fragile:** The application checks for the correct number of arguments (`argc != 6`) but does no validation on the content of the arguments. Passing non-numeric values for `n_transactions` or `trials` will cause `strtoul` to return 0, potentially leading to incorrect behavior or crashes without a clear error message.
- **Safe modification:** Add checks after calling `strtoul` to ensure the values are within an expected range and that the conversion was successful.

## Security Considerations

**Potential Buffer Overflow:**
- **Area:** File I/O
- **Risk:** The `read_file` function in `gpu_mining_starter.cu` is vulnerable to a buffer overflow if a line in the input CSV exceeds the buffer's static size (100 characters). This could be exploited if the input data is not trusted, potentially leading to arbitrary code execution.
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`
- **Current mitigation:** None.
- **Recommendations:** Replace the fixed-size buffer with a safer method of reading file lines, such as one that dynamically allocates memory.

## Known Bugs

- Not detected. The primary issues are unimplemented features rather than incorrect behavior in existing features.

## Performance Bottlenecks

- Not applicable. The performance-critical sections are explicitly marked as `TODO` and are not yet implemented on the target hardware (GPU).

## Scaling Limits

- Not detected.

## Dependencies at Risk

- Not detected. Dependencies are standard C libraries and the CUDA toolkit.

## Missing Critical Features

- GPU-based hashing and reduction are the critical missing features, tracked as Tech Debt.

## Test Coverage Gaps

- **Untested area:** Error handling and input validation.
- **What's not tested:** The autograder scripts (`autograder_*.py`) likely focus on the functional correctness of the algorithm. They are unlikely to test for edge cases like malformed input files (lines > 100 chars) or invalid command-line arguments.
- **Files:** `Khor_Arika_Project_4/Problem_1/gpu_mining_starter.cu`
- **Risk:** The application may fail ungracefully when presented with unexpected inputs.
- **Priority:** Low, for the context of a class project, but would be High in a production environment.

---

*Concerns audit: 2024-07-25*
