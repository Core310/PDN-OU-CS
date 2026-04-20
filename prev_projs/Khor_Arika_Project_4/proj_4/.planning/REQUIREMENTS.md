# Requirements

## Version
**v1**

This document outlines the functional and non-functional requirements for the GPU Accelerated Scientific Computing project.

## Functional Requirements

The project is divided into four main problems.

### Setup (SETUP)
| ID | Description |
|---|---|
| SETUP-01 | Configure the development environment on the HPC cluster by loading the required CUDA and GCC modules. |
| SETUP-02 | Compile and run the provided serial and starter GPU code successfully to verify the environment. |
| SETUP-03 | Be able to submit jobs to the Slurm scheduler using the provided `.sbatch` scripts. |

### Problem 1: Cryptocurrency Mining - Hashing (P1)
| ID | Description |
|---|---|
| P1-01 | Implement a CUDA kernel to generate hash values for each nonce in parallel on the GPU. |
| P1-02 | The hash generation logic must be moved from the CPU `for` loop in `gpu_mining_starter.cu` to the new kernel. |
| P1-03 | The host code must be updated to launch the hash generation kernel and manage necessary memory transfers. |
| P1-04 | The implementation must produce the correct hash values, matching the output of the serial version. |

### Problem 2: Cryptocurrency Mining - Reduction (P2)
| ID | Description |
|---|---|
| P2-01 | Implement a CUDA kernel to perform a parallel reduction to find the minimum hash value and its corresponding nonce. |
| P2-02 | The reduction logic must replace the serial `for` loop in `gpu_mining_starter.cu`. |
| P2-03 | The host code must be updated to launch the reduction kernel and retrieve the final minimum value from the GPU. |
| P2-04 | The implementation must correctly identify the same minimum hash and nonce as the serial version. |

### Problem 3: 2D Image Convolution (P3)
| ID | Description |
|---|---|
| P3-01 | Implement a CUDA kernel to perform a 2D convolution operation on an input image matrix. |
| P3-02 | The host code must read the input image data, transfer it to the GPU, launch the convolution kernel, and retrieve the result. |
| P3-03 | The output of the GPU convolution must be functionally identical to the output of the provided `convolution_serial.c`. |

### Problem 4: Convolution with Max Pooling (P4)
| ID | Description |
|---|---|
| P4-01 | Implement a CUDA kernel to perform a max pooling operation on the output of the convolution. |
| P4-02 | The host code must be updated to orchestrate the sequence of convolution followed by max pooling. |
| P4-03 | The final output must be functionally identical to the output of the provided `convolution_maxpooling_serial.c`. |

## Non-Functional Requirements (NFR)

| ID | Category | Description |
|---|---|---|
| NFR-01 | Performance | The GPU implementation for each problem must demonstrate a significant performance speedup compared to the corresponding serial CPU version. |
| NFR-02 | Correctness | The output of each GPU implementation must exactly match the output of the corresponding serial implementation for the given test data. |
| NFR-03 | Code Quality | Code should follow the existing conventions outlined in `.planning/codebase/CONVENTIONS.md` (e.g., naming, error handling). |
| NFR-04 | Robustness | Address the fragile fixed-size buffer in `read_file` (`gpu_mining_starter.cu`) to prevent potential buffer overflows. |
| NFR-05 | Robustness | Improve command-line argument parsing in `gpu_mining_starter.cu` to handle invalid inputs gracefully. |
| NFR-06 | Testing | All implemented GPU solutions must pass the provided autograder scripts (`autograder_*.py`). |

## Traceability

| Requirement | Phase | Status |
|---|---|---|
| SETUP-01 | 1 | Pending |
| SETUP-02 | 1 | Pending |
| SETUP-03 | 1 | Pending |
| P1-01 | 2 | Pending |
| P1-02 | 2 | Pending |
| P1-03 | 2 | Pending |
| P1-04 | 2 | Pending |
| P2-01 | 3 | Pending |
| P2-02 | 3 | Pending |
| P2-03 | 3 | Pending |
| P2-04 | 3 | Pending |
| P3-01 | 4 | Complete |
| P3-02 | 4 | Complete |
| P3-03 | 4 | Complete |
| P4-01 | 5 | Pending |
| P4-02 | 5 | Pending |
| P4-03 | 5 | Pending |
| NFR-01 | 6 | Pending |
| NFR-02 | 6 | Pending |
| NFR-03 | 6 | Pending |
| NFR-04 | 6 | Pending |
| NFR-05 | 6 | Pending |
| NFR-06 | 6 | Pending |
