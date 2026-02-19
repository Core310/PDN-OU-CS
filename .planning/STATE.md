# Project State: Project 3

## Project Status: Complete
- [x] Phase 1: Problem 2 (Average TF) - Complete
- [x] Phase 2: Problem 3 (Median TF) - Complete
- [x] Phase 3: Problem 4 (K-means Clustering) - Complete
- [x] Phase 4: Build System Consolidation - Complete
- [x] Phase 5: Report Generation - Complete

## Summary of Accomplishments
- **Modular Architecture:** Centralized all shared genomic and environment setup logic in the `setup/` module.
- **Problem 2:** Implemented all required mutual exclusion variants (Critical, Atomic, Locks) and load balancing (Schedule) with minimalist, requirement-linked commenting.
- **Problem 3:** Implemented Baseline and high-performance Map-Reduce median strategies using flat-matrix memory management.
- **Problem 4:** Implemented a robust parallel K-means algorithm with local thread-reductions to eliminate false sharing.
- **Build System:** Standardized all sub-Makefiles and created a root Makefile for project-wide compilation.
- **Documentation:** Created a comprehensive report template (`Khor_Arika_Project_3_Report.md`) following the Project 2 format with detailed technical descriptions.

## Next Steps for User
1. Run `make all` in the root directory to build every binary.
2. Execute the binaries on the Schooner cluster using the provided `.sbatch` scripts (or your own).
3. Fill in the performance results tables in `Khor_Arika_Project_3_Report.md`.
4. Finalize the Scalability Analysis section in the report.
