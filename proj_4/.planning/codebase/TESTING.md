# Testing Patterns

**Analysis Date:** 2024-07-25

## Test Framework

**Runner:**
- **Custom Python Scripts:** The project does not use a standard test runner like `pytest` or `unittest`. Instead, a suite of custom Python scripts (`autograder_*.py`) serve as the test execution engine.
- **Base Class:** A base class, `Base_Autograder` (located in `autograder_base.py`), provides common functionality. Specific test scripts inherit from this class.

**Assertion Library:**
- **File Comparison:** There is no traditional assertion library. Assertions are performed by running the compiled C/CUDA executables, saving their output to files (usually `.csv`), and comparing these against pre-defined "golden" result files.
- **Libraries Used:** `pandas` and `numpy` are used within the autograder scripts to load and compare the output files.

**Run Commands:**
```bash
# Tests are run by executing the Python autograder scripts directly
python Khor_Arika_Project_4/autograder_project_4.py

# Individual problem tests can also be run
python Khor_Arika_Project_4/autograder_problem_4_1.py
```
There are also `.sbatch` files, suggesting tests are intended to be run on a Slurm cluster.

## Test File Organization

**Location:**
- Test scripts are located in the `Khor_Arika_Project_4/` directory. They are not co-located with the source code being tested.
- Test *data* and expected outputs are stored in the `test_data/` directory at the project root.

**Naming:**
- Test scripts follow the pattern `autograder_problem_*.py` or `autograder_project_*.py`.

**Structure:**
```
[project-root]/
├── Khor_Arika_Project_4/
│   ├── autograder_problem_4_1.py  # Test script for Problem 1
│   ├── autograder_problem_4_2.py  # Test script for Problem 2
│   ├── ...
│   └── Problem_1/                 # Source code for Problem 1
│       └── gpu_mining_starter.cu
└── test_data/
    └── Problem_1_and_2/
        ├── in_20k.csv             # Input data for tests
        └── gpu_nonce_files/
            └── out_gpu_20k_5m.csv # Expected ("golden") output
```

## Test Structure

**Suite Organization:**
- Each `autograder_*.py` file represents a test suite for a specific problem.
- Within each suite, the `autograde()` method defines the series of tests to be run.
- The pattern involves:
    1. Defining paths to student executables and output locations.
    2. Defining paths to test data and expected output files.
    3. Constructing the shell commands needed to run the student's executable with the correct arguments.
    4. Calling a helper method (`grade_problem`) that executes the command, waits for the output file to be created, and then compares it to the expected output file.
- Example from `Khor_Arika_Project_4/autograder_problem_4_1.py`:
  ```python
  class Autograder_4_1(Base_Autograder):
      def autograde(self):
          # ... setup paths and commands ...
          
          # Command to run the student's code
          c_p1 = [
              "gpu_mining_problem1",
              "input_file.csv",
              20000,
              5000000,
              "output_file.csv",
              "time_file.csv"
          ]

          # ... loop through tests ...
          result = self.grade_problem(
              problem_dir,
              [expected_output_path],
              [actual_output_path],
              [c_p1],
              is_numeric_comparison
          )
          # ... process result ...
  ```

## Mocking

**Framework:**
- Not applicable. The testing strategy relies exclusively on running the actual compiled programs.

**Patterns:**
- No mocking is used. The tests are full integration tests that exercise the C/CUDA executables.

## Fixtures and Factories

**Test Data:**
- Test data is managed as static files, primarily CSVs.
- These "golden files" serve as both inputs and expected outputs for the test runs.
- They are stored in `test_data/` and organized by the problem they apply to.

## Coverage

**Requirements:**
- No code coverage tools (like `gcov`) or requirements are detected.
- Coverage is implicit; a test passes if the executable runs and produces the correct output file for a given input. The breadth of test cases determines the functional coverage.

## Test Types

**Unit Tests:**
- **Not Used:** There is no evidence of unit testing for either the Python autograder framework or the C/CUDA source code.

**Integration Tests:**
- **Primary Focus:** All tests in this project are integration tests. They verify the behavior of the complete, compiled program from the command line, checking its ability to process input files and generate correct output files.

**E2E Tests:**
- Not applicable in a traditional sense, but the integration tests serve a similar role by validating the full program flow.

---

*Testing analysis: 2024-07-25*
