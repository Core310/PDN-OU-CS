# Project 2 Report
**Author:** Arika Khor

(pre note, I accidently used "we" a bunch since I'm used to that but it was just me that made the code :)

## Problem 1: Matrix-Matrix Multiplication

### Algorithm Description
Parallel matrix-matrix multiplication implemented using OpenMP library as covered in class. 
To optimize performance, an **IKJ** loop order was employed instead of the traditional IJK order (see citation 1 in code). This modification ensures that the innermost loop iterates over the columns of Matrix B and the result Matrix C sequentially, which significantly improves cache locality and reduces cache misses.

The outer loop (iterating over rows of Matrix A) is parallelized using `#pragma omp parallel for`. This distributes the computation of different rows of the result matrix among the available threads.

### Performance Results

#### Runtime (seconds)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 3.666669 | 7.309913 | 14.62543 | 29.37150 |
| **p = 2** | 1.834874 | 3.671434 | 7.332315 | 14.714624 |
| **p = 4** | 0.918707 | 1.838116 | 3.680999 | 7.358336 |
| **p = 8** | 0.461977 | 0.923786 | 1.840274 | 3.679138 |

#### Speedup ($S = T_1 / T_p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 1.998 | 1.991 | 1.995 | 1.996 |
| **p = 4** | 3.991 | 3.977 | 3.973 | 3.992 |
| **p = 8** | 7.937 | 7.913 | 7.947 | 7.983 |

#### Efficiency ($E = S / p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 0.999 | 0.996 | 0.997 | 0.998 |
| **p = 4** | 0.998 | 0.994 | 0.993 | 0.998 |
| **p = 8** | 0.992 | 0.989 | 0.993 | 0.998 |

Tables made using markdown in Obsidan.

### Scalability Analysis
Implementation demonstratesstrong scalability. 
- As the number of threads increases for a fixed problem size, the speedup remains linear, and efficiency close to 1.0. 
- Expected for parallel tasks s/a matrix-matrix multiplication. 
- Each row of the result can be computed independently with minimal overhead.

---

## Problem 2A: Matrix Maximum Reduction

### Algorithm Description
Problem 2A calculates the dot product of rows and columns to find the maximum value in the resulting matrix $C = A \times B$ without storing the matrix itself. This is an memory-efficient approach for finding a single global property of a product matrix. The implementation uses `#pragma omp parallel for` with a `reduction(max:global_maximum)` clause, which allows OpenMP to handle thread-safe updates to the maximum value efficiently.

### Performance Results

#### Runtime (seconds)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 4.482382 | 9.111512 | 18.151642 | 45.749173 |
| **p = 2** | 2.247014 | 4.553675 | 9.116896 | 23.130594 |
| **p = 4** | 1.119866 | 2.341322 | 4.681423 | 11.553419 |
| **p = 8** | 0.615723 | 1.159989 | 2.319032 | 5.845352 |

#### Speedup ($S = T_1 / T_p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 1.995 | 2.001 | 1.991 | 1.978 |
| **p = 4** | 4.003 | 3.892 | 3.877 | 3.960 |
| **p = 8** | 7.279 | 7.855 | 7.827 | 7.827 |

#### Efficiency ($E = S / p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 0.997 | 1.000 | 0.995 | 0.989 |
| **p = 4** | 1.001 | 0.973 | 0.969 | 0.990 |
| **p = 8** | 0.910 | 0.982 | 0.978 | 0.978 |

---

## Problem 2B: Second Largest Value

### Algorithm Description
2B extends reduction pattern to find the second-largest value in the product matrix. 

Given OpenMP doesn't have a built-in reduction for finding "top 2" values, we implemented this using manual reduction. Each thread computes the local top two values for its assigned portion of the matrix. These local results are then merged into the global maximum and second-maximum within an `#pragma omp critical` section.

### Performance Results 

#### Runtime (seconds)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 4.382245 | 8.911974 | 17.372908 | 45.800361 |
| **p = 2** | 2.195352 | 4.445636 | 8.744147 | 23.158579 |
| **p = 4** | 1.089234 | 2.274059 | 4.430408 | 11.619776 |
| **p = 8** | 0.588169 | 1.146641 | 2.330764 | 5.821782 |

#### Speedup ($S = T_1 / T_p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 1.996 | 2.005 | 1.987 | 1.978 |
| **p = 4** | 4.023 | 3.919 | 3.921 | 3.942 |
| **p = 8** | 7.451 | 7.772 | 7.454 | 7.867 |

#### Efficiency ($E = S / p$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :--- | :--- | :--- | :--- |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 0.998 | 1.002 | 0.993 | 0.989 |
| **p = 4** | 1.006 | 0.980 | 0.980 | 0.985 |
| **p = 8** | 0.931 | 0.972 | 0.932 | 0.983 |

---

## Problem 3: Caesar Cipher Encryption

### Algorithm Description
- Encryption algorithm reads input into memory.
- Parallelizes encryption via dividing the buffer into chunks then assigning each chunk to a thread
- Char shifted by key/value using modular arithmetic (there's a lot of really weird stuff with why we used `unsigned char` for the 256 char alph).

### Data Distribution
Data distributed among processors using OpenMP's `static` schedule. 
- Function divides total # of chars (`lSize`) by the # of threads (`num_threads`).
- Then assigns contiguous blocks of text to e/a thread. Minimizes overhead as the workload per character is constant.

### Performance (i wonder if i used max threads)

#### Runtime (seconds)

| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :---: | :---: | :---: | :---: | :---: |
| **p = 1** | 0.060548 | 0.120680 | 0.278142 | 0.628040 |
| **p = 2** | 0.030350 | 0.060739 | 0.140267 | 0.316165 |
| **p = 4** | 0.015782 | 0.031169 | 0.072869 | 0.160952 |
| **p = 8** | 0.007995 | 0.015662 | 0.036156 | 0.080929 |




#### Speedup ($S = T_1 / T_p$)

| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :---: | :---: | :---: | :---: | :---: |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 1.995 | 1.987 | 1.983 | 1.986 |
| **p = 4** | 3.837 | 3.872 | 3.817 | 3.902 |
| **p = 8** | 7.573 | 7.705 | 7.693 | 7.760 |



#### Efficiency ($E = S / p$)


| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :---: | :---: | :---: | :---: | :---: |
| **p = 1** | 1.000 | 1.000 | 1.000 | 1.000 |
| **p = 2** | 0.998 | 0.993 | 0.991 | 0.993 |
| **p = 4** | 0.959 | 0.968 | 0.954 | 0.976 |
| **p = 8** | 0.947 | 0.963 | 0.962 | 0.970 |

### Scalability Analysis

Encryption program scales well. Even though the computation per character is very simple (a single addition), the overhead of thread management in OpenMP is low enough that we still achieve over 94% efficiency with 8 threads on the larger test cases. The scaling is consistent across different file sizes, indicating that the embarrassingly parallel nature of block ciphers is well-suited for this approach.

---



## Problem 4: Brute-Force Decryption







### Algorithm Description
Decryption problem involves brute forcing Caesar cipher via testing 256 possible keys. For each key,  entire ciphertext is decrypted into a temp buffer, and # of occurrences of the common English word "the" is counted (regardless of case). Key which produces highest count of "the" is then identified as correct key.


To parallelize, 256 possible keys are distributed among threads. Each thread maintains its own local maximum count + local best key, additionally each has its own private buffer for decryption (learnt this the hard way after getting a race condition and banging my head against the wall several times). After exploring assigned range of keys, each thread performs critical section updating global max + best key.
### Performance Results

#### Runtime (seconds)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :---: | :---: | :---: | :---: |
| **p = 1** | 24.763516 | N/A | N/A | N/A |
| **p = 2** | 12.578591 | N/A | N/A | N/A |
| **p = 4** | 6.437307 | N/A | N/A | N/A |
| **p = 8** | 3.234761 | N/A | N/A | N/A |

#### Speedup (\$S = T\_1 / T\_p\$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :---: | :---: | :---: | :---: |
| **p = 1** | 1.000 | - | - | - |
| **p = 2** | 1.969 | - | - | - |
| **p = 4** | 3.847 | - | - | - |
| **p = 8** | 7.655 | - | - | - |

#### Efficiency (\$E = S / p\$)
| Threads | Test 1 | Test 2 | Test 3 | Test 4 |
| :--- | :---: | :---: | :---: | :---: |
| **p = 1** | 1.000 | - | - | - |
| **p = 2** | 0.985 | - | - | - |
| **p = 4** | 0.962 | - | - | - |
| **p = 8** | 0.957 | - | - | - |


### Scalability Analysis
Brute-force decryption demonstrates good scalability. Given all key trials are independent of each other, the main overhead is the initial buffer allocation and the final critical section. Efficiency remains above 95% with 8 threads. Shows compute-intensive search problems benfit greatly from parallelization.





 