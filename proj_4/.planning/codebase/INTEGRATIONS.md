# External Integrations

**Analysis Date:** 2024-07-25

## APIs & External Services

- **None Detected:** The project is self-contained and does not make calls to external web APIs or services. The primary "integration" is with the local hardware.

**Hardware Integration:**
- **NVIDIA GPU:** The application integrates directly with the system's GPU via the CUDA API. This is the core purpose of the project.
  - SDK/Client: `CUDA Toolkit 10.1.243`
  - Auth: Not applicable. Access is managed by the underlying operating system and Slurm scheduler.

## Data Storage

**Databases:**
- **None Detected:** The project does not connect to a database.

**File Storage:**
- **Local Filesystem:** All data input and output is handled via local files.
  - **Input:** Reads data from `.csv` files (e.g., `test_data/Problem_1_and_2/in_20k.csv`).
  - **Output:** Writes results and timing information to new `.csv` files in the same directory as the executable.

**Caching:**
- **None Detected:** There is no persistent caching layer.

## Authentication & Identity

- **Not Applicable:** The application is a command-line tool for computation and does not have users or authentication.

## Monitoring & Observability

**Error Tracking:**
- **None Detected:** No external error tracking service is used. Errors are reported to `stderr` and captured in log files specified by Slurm (`_P4-1_%J_stderr.txt`).

**Logs:**
- **Standard Output/Error:** Logging is done via `printf` statements to `stdout` and `stderr`.
- **Slurm Log Files:** When run via `sbatch`, `stdout` and `stderr` are redirected to files in the execution directory, as defined in the `.sbatch` scripts.

## CI/CD & Deployment

**Hosting:**
- **HPC Cluster:** The application is intended to be run on a High-Performance Computing cluster managed by the **Slurm Workload Manager**.

**CI Pipeline:**
- **None Detected:** There are no configuration files for CI services like GitHub Actions, Jenkins, etc.

**Deployment:**
- **Manual:** Deployment consists of copying the source code to the HPC cluster, compiling it with `make`, and submitting jobs with `sbatch`.

## Environment Configuration

**Required env vars:**
- **None Detected:** The application does not appear to use environment variables for configuration. Configuration is passed via command-line arguments. The build environment relies on `PATH` and `LD_LIBRARY_PATH` being correctly set by the `module load` command.

**Secrets location:**
- **Not Applicable:** There are no secrets or credentials.

## Webhooks & Callbacks

- **Not Applicable:** The application does not use webhooks.

---

*Integration audit: 2024-07-25*
