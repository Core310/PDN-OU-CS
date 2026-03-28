# External Integrations

**Analysis Date:** 2024-07-25

## APIs & External Services

**Category: None**
- This project is self-contained and focuses on local, high-performance computation. No calls to external web APIs or services were detected.

## Data Storage

**Databases:**
- None. The application does not connect to a database.

**File Storage:**
- **Local Filesystem Only:** The application reads input data exclusively from local `.csv` files (e.g., `test_data/Problem_1_and_2/debug_1k.csv`).
- It writes its output and timing results to new `.csv` files in the respective problem directories.

**Caching:**
- None detected.

## Authentication & Identity

**Auth Provider:**
- Not applicable. The application runs locally and has no concept of users or authentication.

## Monitoring & Observability

**Error Tracking:**
- None. Errors are typically handled by printing to `stderr` or are surfaced through compiler errors.

**Logs:**
- Logging is informal, consisting of `printf` statements in the C/CUDA code to print progress or results to `stdout`. There is no structured logging framework.

## CI/CD & Deployment

**Hosting:**
- Not applicable. This is a command-line application, not a hosted service.

**CI Pipeline:**
- None detected. The project does not contain configuration for services like GitHub Actions, Travis CI, etc.
- The project is submitted for grading via `.sbatch` files, which are scripts for the Slurm Workload Manager, indicating deployment to a High-Performance Computing (HPC) cluster.

## Environment Configuration

**Required env vars:**
- No reliance on environment variables for configuration was detected. All configuration is passed as command-line arguments.

**Secrets location:**
- Not applicable. The application uses no secrets.

## Webhooks & Callbacks

**Incoming:**
- None.

**Outgoing:**
- None.

---
*Integration audit: 2024-07-25*
