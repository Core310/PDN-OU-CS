#!/bin/bash

#we use same logic from problem one
# NOTE THAT I DID USE A BIT OF LLM TO GENERATE THE LOGIC BUT NOT THE ACTUAL CODE IN QUESTION
# I went with just copying instead of for loop cos easier to read lol

gcc -O3 -fopenmp decrypt_parallel.c -o decrypt_parallel
# 1 thread
./decrypt_parallel input_text.txt key.txt time.txt 1
T1=$(cat time.txt)
echo "1,$T1,1.0,1.0" > decryption_results.csv
# 2 thread
./decrypt_parallel input_text.txt key.txt time.txt 2
T2=$(cat time.txt)
S2=$(awk "BEGIN {print $T1 / $T2}")
E2=$(awk "BEGIN {print $S2 / 2}")
echo "2,$T2,$S2,$E2" >> decryption_results.csv
# 4 thread
./decrypt_parallel input_text.txt key.txt time.txt 4
T4=$(cat time.txt)
S4=$(awk "BEGIN {print $T1 / $T4}")
E4=$(awk "BEGIN {print $S4 / 4}")
echo "4,$T4,$S4,$E4" >> decryption_results.csv
# 8 thread
./decrypt_parallel input_text.txt key.txt time.txt 8
T8=$(cat time.txt)
S8=$(awk "BEGIN {print $T1 / $T8}")
E8=$(awk "BEGIN {print $S8 / 8}")
echo "8,$T8,$S8,$E8" >> decryption_results.csv