#!/bin/bash

gcc -fopenmp encrypt_parallel.c -o encrypt_parallel
#ultra lei zei method (lei lei loh moh)
./encrypt_parallel 5 data1.txt out1_t1.txt time.txt 1
./encrypt_parallel 5 data1.txt out1_t2.txt time.txt 2
./encrypt_parallel 5 data1.txt out1_t4.txt time.txt 4
./encrypt_parallel 5 data1.txt out1_t8.txt time.txt 8

./encrypt_parallel 5 data2.txt out2_t1.txt time.txt 1
./encrypt_parallel 5 data2.txt out2_t2.txt time.txt 2
./encrypt_parallel 5 data2.txt out2_t4.txt time.txt 4
./encrypt_parallel 5 data2.txt out2_t8.txt time.txt 8

./encrypt_parallel 5 data3.txt out3_t1.txt time.txt 1
./encrypt_parallel 5 data3.txt out3_t2.txt time.txt 2
./encrypt_parallel 5 data3.txt out3_t4.txt time.txt 4
./encrypt_parallel 5 data3.txt out3_t8.txt time.txt 8

./encrypt_parallel 5 data4.txt out4_t1.txt time.txt 1
./encrypt_parallel 5 data4.txt out4_t2.txt time.txt 2
./encrypt_parallel 5 data4.txt out4_t4.txt time.txt 4
./encrypt_parallel 5 data4.txt out4_t8.txt time.txt 8