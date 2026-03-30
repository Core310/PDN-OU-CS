# External Integrations

**Analysis Date:** 2025-05-14

## APIs & External Services

**Distributed Computing:**
- Message Passing Interface (MPI) - Implementation-agnostic API for communication between parallel processes.
  - SDK/Client: `OpenMPI 4.1.4` (or similar cluster-provided implementation).
  - Auth: Cluster-level account access via SLURM.

## Data Storage

**Databases:**
- Not applicable (No databases used).

**File Storage:**
- Local Filesystem / Cluster Shared Storage: Results are typically written to `.csv` files (e.g., `time_1M_diff.csv` in `Problem_1/pingpong_diffnode.sbatch`).
- Input Data: Test vectors and expected outputs stored in `.csv` format under `tests/Project_5_Tests/test_data/`.

**Caching:**
- None.

## Authentication & Identity

**Auth Provider:**
- Cluster-level Authentication: Handled by the HPC system (e.g., OUCSPDN cluster) through SSH and SLURM credentials.

## Monitoring & Observability

**Error Tracking:**
- None.

**Logs:**
- SLURM Output/Error logs: Standard output and standard error are redirected to specific files as defined in `.sbatch` directives.
  - Pattern: `_P5-1_diff_%J_stdout.txt` (where `%J` is the Job ID).

## CI/CD & Deployment

**Hosting:**
- HPC Cluster: OUCSPDN-managed cluster nodes.

**CI Pipeline:**
- None detected (Manual trigger of `autograder_project_5.sbatch`).

## Environment Configuration

**Required env vars:**
- None explicitly defined in scripts, but SLURM sets several (e.g., `SLURM_NTASKS`, `SLURM_JOB_ID`).

**Secrets location:**
- Not applicable (No external secrets/keys detected in the codebase).

## Webhooks & Callbacks

**Incoming:**
- None.

**Outgoing:**
- SLURM Mail Notifications: Defined in `.sbatch` scripts (e.g., `#SBATCH --mail-user=arikak@ou.edu`, `#SBATCH --mail-type=ALL`).

---

*Integration audit: 2025-05-14*
