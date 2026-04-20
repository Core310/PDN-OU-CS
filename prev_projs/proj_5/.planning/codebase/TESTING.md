# Testing Patterns

**Analysis Date:** 2023-10-27

## Test Framework

**Runner:**
- Custom Python-based autograder in `tests/Project_5_Tests/Autograder/autograder_project_5.py`.
- Inherits from `Base_Autograder` in `tests/Project_5_Tests/Autograder/autograder_base.py`.
- Bash scripts for batch execution: `tests/Project_5_Tests/Autograder/test_scripts/*.sh`.

**Assertion Library:**
- `numpy.array_equal` (exact comparison).
- Custom `is_error_within_bound` method for approximate values (e.g., Pi estimation).
- `filecmp.cmp` (optional exact file text comparison).

**Run Commands:**
```bash
python3 -u autograder_project_5.py    # Run all tests
python3 -u autograder_problem_5_2.py  # Run problem 2 tests
bash 2_batch.sh                       # Manual batch execution for Problem 2
```

## Test File Organization

**Location:**
- Separate: `tests/Project_5_Tests/Autograder/` contains scripts.
- Test Data: `tests/Project_5_Tests/test_data/` contains expected results and input vectors.

**Naming:**
- `autograder_problem_5_X.py` where X is the problem number.
- `X_batch.sh` where X is the problem number.

**Structure:**
```
tests/Project_5_Tests/
├── Autograder/
│   ├── autograder_base.py
│   ├── autograder_problem_5_2.py
│   ├── autograder_project_5.py
│   └── test_scripts/
│       └── 2_batch.sh
└── test_data/
    ├── Problem_2/
    └── Vectors/
```

## Test Structure

**Suite Organization:**
```python
class Autograder_5_2(Base_Autograder):
    def __init__(self, ...):
        # Setup student files, test data directories, and problem-specific params
        self.student_files = "Problem_2"
        self.threads = [2, 4, 8]
        ...

    def autograde(self):
        # Generate commands, execute grade_problem, and record results in pandas DataFrame
        for thread in self.threads:
            result = self.grade_problem(...)
```

**Patterns:**
- `grade_problem`: handles compilation (`make`), execution, and result verification.
- `numpy` is used to load and compare CSV files containing numeric results.
- `pandas` is used to store and output final grades and timings.

## Mocking

**Framework:** None.
**Patterns:**
- Real MPI execution is required.
- Students must provide a `Makefile` in each problem directory for the autograder to compile the source.

**What to Mock:** Not applicable.
**What NOT to Mock:** MPI calls, file I/O.

## Fixtures and Factories

**Test Data:**
```python
# Input vector files in Autograder_5_2.py
t_vectors_1 = [
    os.path.join(test_in_dir, "vec1_2^18.csv"),
    ...
]
```

**Location:**
- `tests/Project_5_Tests/test_data/Vectors/` contains input CSV vectors.
- `tests/Project_5_Tests/test_data/Problem_X/` contains expected output CSV files.

## Coverage

**Requirements:** None enforced in the provided scripts.
**View Coverage:** Not configured.

## Test Types

**Unit Tests:** Not detected.
**Integration Tests:**
- The autograder acts as an integration test runner, executing the compiled binaries against known inputs.
**E2E Tests:**
- The autograder checks final outputs and performance (timing) against requirements.

## Common Patterns

**Async Testing:**
- Not applicable (standard `os.system` calls for execution).
- Batch scripts use `mpirun` for parallel execution.

**Error Testing:**
- `grade_problem` catches exceptions during file loading and binary execution.
- Checks for existence of `Makefile`.
- Reports missing output files or dimension mismatches.

---

*Testing analysis: 2023-10-27*
