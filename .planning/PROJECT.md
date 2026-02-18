# Project 3: Parallel Bioinformatics Algorithms

## Overview
This project involves parallelizing several bioinformatics algorithms using OpenMP. The main tasks include computing average and median tetranucleotide frequencies (TF) and implementing K-means clustering for gene data.

## Objectives
- Implement `process_tetranucs` and parallelize the TF computation for average and median.
- Implement parallel K-means clustering.
- Ensure high code readability and maintainability.
- Optimize for performance on the OSCER Slurm cluster.

## Tech Stack
- **Language:** C
- **Parallelization:** OpenMP (primary focus)
- **Environment:** Linux / Slurm (OSCER)
- **Build System:** Makefile

## Key Files
- `Project_3_Problems/Khor_Arika_Project_3/Problem_2/compute_average_TF_Exp1_starter.c`: Starter for average TF.
- `Project_3_Problems/Khor_Arika_Project_3/Problem_3/compute_median_TF_Exp1_starter.c`: Starter for median TF.
- `Project_3_Problems/Khor_Arika_Project_3/Problem_4/kmeans_clustering_starter.c`: Starter for K-means.

## Constraints
- Focus on OpenMP for parallelization.
- Prioritize readability over extreme micro-optimizations.
- Follow existing starter code structure and patterns.
