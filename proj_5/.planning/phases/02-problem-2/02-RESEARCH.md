# Phase 2: Problem 2 (Parallel Dot Product) - Research

**Researched:** 2024-11-20
**Domain:** MPI Programming, Collective Communication
**Confidence:** HIGH

## Summary

This phase involves implementing a parallel dot product using MPI collective communication operations, specifically `MPI_Scatter` and `MPI_Reduce`. The goal is to achieve an embarrassingly parallel computation where each process computes a subset of the dot product, and the partial results are summed at the end.

**Primary recommendation:** Use `MPI_Scatter` to distribute chunks of the input vectors from Process 0 to all processes, and `MPI_Reduce` with the `MPI_SUM` operation to combine the partial dot products on Process 0.

## User Constraints (from CONTEXT.md)

*Note: No CONTEXT.md was provided for this phase. Derived from PROJECT.md and Phase description.*

### Locked Decisions
- **Language:** C with MPI.
- **Collectives:** Must use `MPI_Scatter` and `MPI_Reduce`.
- **CLI:** `dot_product_MPI n_items vec_1.csv vec_2.csv result.csv time.csv`.
- **Precision:** Use `%.6f` for results and times in CSV output.
- **Commenting:** No `//` comments; use `/* */` only.
- **Traceability:** Logic derived from instructions must quote `Project_5_Instructions.pdf`.

### the agent's Discretion
- Memory allocation strategies (though contiguous is required for Scatter).
- Synchronization points (e.g., barriers) for timing.
- CSV parsing robustness beyond the serial reference.

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| REQ-2.1 | Parallelize dot product using `MPI_Scatter` and `MPI_Reduce`. | Verified strategy: Scatter for distribution, Reduce for summation. |
| REQ-2.2 | CLI: `dot_product_MPI n_items vec_1.csv vec_2.csv result.csv time.csv`. | Matched against autograder and PDF instructions. |
| REQ-2.3 | Process 0 reads inputs and writes outputs. | Memory management for rank 0 vs others identified. |
| REQ-2.4 | Mandatory use of `/* */` comments and quoting PDF. | Quoted passages from Page 6 of instructions identified. |
| REQ-2.5 | Use `%.6f` precision for floating point output. | Matched against serial reference and user mandate. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| MPI | 1.0+ | Message Passing Interface | Standard for parallel programming in C. |
| OpenMPI | 4.1.6 | Runtime / Implementation | High performance MPI implementation on the target cluster. |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|--------------|
| stdio.h | - | File I/O (CSV) | Reading input vectors and writing results. |
| stdlib.h| - | Memory Allocation | `malloc`/`free` for vector storage. |

## Architecture Patterns

### Parallel Dot Product Strategy
1. **Input Stage (Rank 0 only):** Reads two vectors from CSV files into large arrays.
2. **Distribution Stage (All ranks):**
   - Rank 0 uses `MPI_Scatter` to send contiguous chunks of both vectors to all ranks.
   - All ranks receive their chunks into local buffers.
3. **Computation Stage (All ranks):**
   - Each rank iterates through its local buffer and computes a partial sum: `partial_dot += a[i] * b[i]`.
4. **Reduction Stage (Rank 0 only):**
   - Use `MPI_Reduce` with `MPI_SUM` to aggregate all `partial_dot` values into `global_dot` on Rank 0.
5. **Output Stage (Rank 0 only):** Writes `global_dot` and `time_spent` to the specified CSV files.

### Recommended Project Structure
```
Problem_2/
├── dot_product_MPI.c   # MPI implementation
├── Makefile            # Build system
├── dot_product.sbatch  # Schooner execution script
└── serial/             # Serial reference implementation
    └── dotprod_serial.c
```

### Memory Management Pitfalls
- **Contiguity:** `MPI_Scatter` requires the send buffer to be a contiguous block of memory. Process 0 should allocate `n_items * sizeof(double)` once.
- **Chunk Sizing:** For $P$ processes and $N$ items, each chunk must be $N/P$. All tested sizes ($2^{18}, 2^{19}, 2^{20}$) are divisible by the process counts (2, 4, 8).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Parallel Summation | Point-to-point Send/Recv | `MPI_Reduce` | Optimized tree-based reduction in MPI library. |
| Data Distribution | Manual Send loops | `MPI_Scatter` | Handles communication topology more efficiently. |
| Timing | `clock()` or `gettimeofday()` | `MPI_Wtime()` | Higher resolution and standardized across MPI implementations. |

## Common Pitfalls

### Pitfall 1: Timing Scope
**What goes wrong:** Timing the whole program execution, including file I/O.
**Why it happens:** Standard `time` command or broad `MPI_Wtime` calls.
**How to avoid:** "Start the timer after reading in the two arrays and stop the timer after the dot product is computed." (Project_5_Instructions.pdf, Page 6).
**Warning signs:** Parallel execution time remains dominated by disk I/O, hiding speedup.

### Pitfall 2: Memory Allocation on Non-Root Processes
**What goes wrong:** Allocating full $N$-sized vectors on all ranks.
**Why it happens:** Copy-pasting serial code into the MPI structure.
**How to avoid:** Only Rank 0 should allocate the global vectors. Other ranks only need local chunk buffers.
**Warning signs:** `Memory limit exceeded` on large $N$.

### Pitfall 3: MPI_Scatter Parameters
**What goes wrong:** Passing `n_items` instead of `chunk_size` to `MPI_Scatter`.
**Why it happens:** Confusion between total items and items-per-process in MPI collective APIs.
**How to avoid:** `MPI_Scatter` takes the count *per destination process*. Use `n_items / comm_size`.

## Code Examples

### MPI Scatter and Reduce
```c
/* Distribute vectors to all processes */
MPI_Scatter(global_vec_1, chunk_size, MPI_DOUBLE, local_vec_1, chunk_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
MPI_Scatter(global_vec_2, chunk_size, MPI_DOUBLE, local_vec_2, chunk_size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

/* Compute local dot product */
double local_dot = 0.0;
for (int i = 0; i < chunk_size; i++) {
    local_dot += local_vec_1[i] * local_vec_2[i];
}

/* Aggregate results on Rank 0 */
double global_dot = 0.0;
MPI_Reduce(&local_dot, &global_dot, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
```

### CSV Reading (matching serial reference)
```c
/* Source: Problem_2/serial/dotprod_serial.c */
char str[25];
while (fgets(str, 25, inputFile) != NULL) {
    sscanf(str, "%lf", &(vec[k++]));
}
```

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| mpicc | Compilation | ✓ | GCC 13.3.0 | - |
| mpirun | Execution | ✓ | OpenMPI 4.1.6| - |
| Schooner Modules | Execution | ✓ | intel, OpenMPI | Use local GCC/OpenMPI |

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Custom Python Autograder |
| Config file | `tests/Project_5_Tests/Autograder/autograder_problem_5_2.py` |
| Quick run command | `python3 tests/Project_5_Tests/Autograder/autograder_problem_5_2.py` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| REQ-2.1 | Parallel Result Accuracy | Integration | `python3 autograder_problem_5_2.py` | ✅ |
| REQ-2.2 | CLI arguments | Smoke | Check return code of `dot_product_MPI` | ✅ |

### Sampling Rate
- **Per task commit:** Compile with `mpicc` to ensure no syntax errors.
- **Per wave merge:** Run single test case with `mpirun -n 2`.
- **Phase gate:** Full autograder pass (2, 4, 8 processes).

## Sources

### Primary (HIGH confidence)
- `Project_5_Instructions.pdf`, Page 6 - Problem description and requirements.
- `Problem_2/serial/dotprod_serial.c` - Reference for logic and I/O.
- `tests/Project_5_Tests/Autograder/autograder_problem_5_2.py` - Reference for validation and output naming.

### Secondary (MEDIUM confidence)
- `Problem_2/dot_product.sbatch` - Current Schooner configuration (needs updates to match data paths).

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Standard MPI usage.
- Architecture: HIGH - Matches textbook "Scatter/Reduce" pattern.
- Pitfalls: HIGH - Identified from serial code comparison and MPI experience.

**Research date:** 2024-11-20
**Valid until:** 2024-12-20
