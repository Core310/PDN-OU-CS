#!/bin/bash

FILE="convolution_maxpooling.cu"

# Fix printf usage message
sed -i 's|printf(USE_LIKE_THIS_MSG);|printf("USE LIKE THIS: convolution_CUDA n_row n_col input.csv results.csv time.csv
");|g' "$FILE"

# Fix fprintf newline for CSV results
sed -i 's|fputs(NEWLINE_STR, resultsFile); // Use macro for newline|fprintf(resultsFile, "
"); // Explicit newline|g' "$FILE"

# Fix fprintf newline for time file
sed -i 's|fputs(NEWLINE_STR, timeFile); // Use macro for newline|fprintf(timeFile, "
"); // Explicit newline|g' "$FILE"

echo "Attempted to fix $FILE. Please try recompiling."
