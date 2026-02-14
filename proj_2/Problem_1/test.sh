#!/bin/bash

gcc -O3 -fopenmp parallel_mult_mat_mat.c -o parallel_mult_mat_mat

thread_counts=(1 2 4 8)

tests=(
    "test1_A.csv 100 100 test1_B.csv 100 100"
    "test2_A.csv 500 500 test2_B.csv 500 500"
    "test3_A.csv 1000 1000 test3_B.csv 1000 1000"
    "test4_A.csv 2000 2000 test4_B.csv 2000 2000"
)

for params in "${tests[@]}"
do
    for t in "${thread_counts[@]}"
    do
        ./parallel_mult_mat_mat $params result_matrix.csv time.csv $t
    done
done
