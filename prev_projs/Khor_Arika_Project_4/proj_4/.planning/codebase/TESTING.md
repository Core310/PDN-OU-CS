# Testing Patterns

**Analysis Date:** 2024-07-29

## Test Framework

**Runner:**
- A custom Python-based testing harness is used. It is not a standard framework like `pytest` or `gtest`.
- The main runner script is `Khor_Arika_Project_4/autograder_project_4.py`.
- It uses `pandas` for analyzing and storing results.
- The core logic appears to be in a `Base_Autograder` class which individual test scripts inherit from.

**Assertion Library:**
- Assertions are done by comparing output files. The `grade_problem` method in the autograder scripts reads the student-generated output and compares it against a pre-computed "golden" output file. It is a form of diff-based testing.

**Run Commands:**
```bash
# To run the full test suite
python Khor_Arika_Project_4/autograder_project_4.py
```

## Test File Organization

**Location:**
- Test scripts are located in `Khor_Arika_Project_4/`.
- Test data (input files and expected output files) is located in the `test_data/` directory, segregated by problem number.
- This represents a clean separation of tests from the application code.

**Naming:**
- Test scripts follow the pattern `autograder_problem_4_[problem_number].py`.

**Structure:**
```
[project-root]/
├── Khor_Arika_Project_4/
│   ├── autograder_project_4.py      # Main test runner
│   ├── autograder_problem_4_1.py    # Tests for Problem 1
│   └── ...
├── Problem_1/
│   └── ... (code to be tested)
└── test_data/
    ├── Problem_1_and_2/
    │   ├── in_20k.csv               # Test input data (fixture)
    │   └── gpu_nonce_files/
    │       └── out_gpu_20k_5m.csv   # Expected ("golden") output
    └── ...
```

## Test Structure

**Suite Organization:**
- The `autograder_project_4.py` script serves as the test suite, importing and running tests for each problem sequentially.
- Each `autograder_problem_4_*.py` file defines a class that configures and executes tests for one problem from the project.

**Patterns:**
- **Setup:** The `__init__` method of each autograder class sets up paths to student code, test data, and defines the specific test cases to run.
- **Execution:** The `autograde` method builds a list of command-line instructions. Each command runs the compiled C/CUDA executable with specific inputs, directing the output to temporary files.
- **Assertion/Grading:** A helper method (`grade_problem`) is called, which orchestrates running the command and comparing the actual output file contents against the expected output file.
- **Teardown:** There is no explicit teardown logic; the test harness simply writes results to `.csv` files.

## Mocking

**Framework:**
- No mocking framework is used.

**Patterns:**
- Mocking is not used. The tests run the actual compiled executables.

**What to Mock:**
- Not applicable.

**What NOT to Mock:**
- The entire application is tested end-to-end.

## Fixtures and Factories

**Test Data:**
- Test fixtures are static `.csv` files located in the `test_data/` directory.
- There is a clear distinction between input files (e.g., `in_20k.csv`) and expected output files (e.g., `out_gpu_20k_5m.csv`).
- There is no dynamic data generation; all test data is pre-generated and checked into the repository.

```python
# Example of fixture paths from autograder_problem_4_1.py

# Expected input
t_p1_in = [
    os.path.join(test_in_dir, "in_20k.csv")
]

# Expected output
t_dir = os.path.join(test_out_dir, "gpu_nonce_files")
t_p1_out = [
    os.path.join(t_dir, "out_gpu_20k_5m.csv"),
    os.path.join(t_dir, "out_gpu_20k_10m.csv")
]
```

**Location:**
- All fixtures reside in the `test_data/` directory.

## Coverage

**Requirements:**
- No code coverage tools (like `gcov`) are configured or used.
- Test coverage is not measured or enforced.

**View Coverage:**
- Not applicable.

## Test Types

**Unit Tests:**
- Not used. Individual functions within the C/CUDA code are not tested in isolation.

**Integration Tests:**
- The entire testing approach is based on integration testing. It verifies the behavior of the complete, compiled program.

**E2E Tests:**
- The tests function as end-to-end tests for a command-line application. They execute the program with arguments and validate the output files, which is the full scope of the application's behavior. The tests also capture performance metrics (timing).

## Common Patterns

**Async Testing:**
- Not applicable.

**Error Testing:**
- The tests primarily focus on "happy path" scenarios by checking for correct output. They do not appear to test for failure cases, such as behavior with invalid input files or incorrect command-line arguments.
---
*Testing analysis: 2024-07-29*
