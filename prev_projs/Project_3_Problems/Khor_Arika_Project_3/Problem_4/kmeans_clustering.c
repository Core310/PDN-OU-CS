#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include <omp.h>
#include <math.h> 
#include <float.h>

#define MAXCHAR 25

/* Helper to compute squared Euclidean distance. */
double get_dist_sq(double x1, double y1, double x2, double y2) {
    double dx = x1 - x2;
    double dy = y1 - y2;
    return dx*dx + dy*dy;
}

int main(int argc, char* argv[]) {
    /* 
     * Req: Page 12 - "Your program should be run using: 
     * kmeans_parallel n_points points.csv n_centroids initial_centroid_values.csv final_centroid_values.csv time.csv num_threads"
     */
    if (argc != 8) {
        fprintf(stderr, "USE LIKE THIS: kmeans_clustering n_points points.csv n_centroids centroids.csv output.csv time.csv num_threads\n");
        exit(-1);
    }

    int num_points = strtol(argv[1], NULL, 10);
    FILE* pointsFile = fopen(argv[2], "r");
    if (pointsFile == NULL) { exit(-2); }

    int num_centroids = strtol(argv[3], NULL, 10);
    FILE* centroidsFile = fopen(argv[4], "r");
    if (centroidsFile == NULL) { fclose(pointsFile); exit(-3); }

    FILE* outputFile = fopen(argv[5], "w");
    FILE* timeFile = fopen(argv[6], "w");
    if (!outputFile || !timeFile) { exit(-4); }

    int num_threads = strtol(argv[7], NULL, 10);
    if (num_threads < 1) { exit(-5); }

    double* points_x = malloc(num_points * sizeof(double));
    double* points_y = malloc(num_points * sizeof(double));
    double* centroids_x = malloc(num_centroids * sizeof(double));
    double* centroids_y = malloc(num_centroids * sizeof(double));
    int* point_assignments = malloc(num_points * sizeof(int));

    if (!points_x || !points_y || !centroids_x || !centroids_y || !point_assignments) {
        fprintf(stderr, "ERROR: malloc fail\n");
        exit(-6);
    }

    char str[MAXCHAR];
    int k = 0;
    while (fgets(str, MAXCHAR, pointsFile) != NULL) {
        if (sscanf(str, "%lf,%lf", &(points_x[k]), &(points_y[k])) == 2) k++;
    }
    fclose(pointsFile);

    k = 0;
    while (fgets(str, MAXCHAR, centroidsFile) != NULL) {
        if (sscanf(str, "%lf,%lf", &(centroids_x[k]), &(centroids_y[k])) == 2) k++;
    }
    fclose(centroidsFile);

    double start = omp_get_wtime();
    omp_set_num_threads(num_threads);

    double total_movement = DBL_MAX;

    /*
     * Req: Page 11 - "The k-means clustering is considered to be converged if the average Euclidean distance 
     * by which the centroids are moved in an iteration is less than 1.0."
     */
    while (total_movement > 1.0) {
        
        /* 
         * Req: Page 12 - "In all the OpenMP parallel directives, please specify the variable scope 
         * clauses [i.e., default(none), shared(), private(), and reduction()] to explicitly 
         * declare the scope of every variable."
         */
        #pragma omp parallel for default(none) shared(num_points, num_centroids, points_x, points_y, centroids_x, centroids_y, point_assignments)
        for (int p = 0; p < num_points; ++p) {
            double min_dist = DBL_MAX;
            int best_c = 0;
            for (int c = 0; c < num_centroids; ++c) {
                double d = get_dist_sq(points_x[p], points_y[p], centroids_x[c], centroids_y[c]);
                if (d < min_dist) {
                    min_dist = d;
                    best_c = c;
                }
            }
            point_assignments[p] = best_c;
        }

        /*
         * Req: Page 12 - "Please consider false sharing when updating different elements in an array."
         * Strategy: Use private thread-local arrays for partial sums and counts to eliminate 
         * false sharing and minimize critical section synchronization.
         */
        double* next_x = (double*)calloc(num_centroids, sizeof(double));
        double* next_y = (double*)calloc(num_centroids, sizeof(double));
        int* counts = (int*)calloc(num_centroids, sizeof(int));

        #pragma omp parallel default(none) shared(num_points, num_centroids, points_x, points_y, point_assignments, next_x, next_y, counts, stderr)
        {
            double* local_x = (double*)calloc(num_centroids, sizeof(double));
            double* local_y = (double*)calloc(num_centroids, sizeof(double));
            int* local_n = (int*)calloc(num_centroids, sizeof(int));

            if (!local_x || !local_y || !local_n) { exit(-7); }

            #pragma omp for
            for (int p = 0; p < num_points; ++p) {
                int c = point_assignments[p];
                local_x[c] += points_x[p];
                local_y[c] += points_y[p];
                local_n[c]++;
            }

            #pragma omp critical
            {
                for (int c = 0; c < num_centroids; ++c) {
                    next_x[c] += local_x[c];
                    next_y[c] += local_y[c];
                    counts[c] += local_n[c];
                }
            }
            free(local_x);
            free(local_y);
            free(local_n);
        }

        total_movement = 0;
        for (int c = 0; c < num_centroids; ++c) {
            if (counts[c] > 0) {
                double nx = next_x[c] / counts[c];
                double ny = next_y[c] / counts[c];
                total_movement += sqrt(get_dist_sq(nx, ny, centroids_x[c], centroids_y[c]));
                centroids_x[c] = nx;
                centroids_y[c] = ny;
            }
        }

        free(next_x);
        free(next_y);
        free(counts);
    }

    double end = omp_get_wtime();

    fprintf(timeFile, "%f", end - start);
    for (int c = 0; c < num_centroids; ++c) {
        fprintf(outputFile, "%.6f, %.6f", centroids_x[c], centroids_y[c]);
        if (c != num_centroids - 1) fprintf(outputFile, "\n");
    }

    fclose(outputFile);
    fclose(timeFile);
    free(points_x);
    free(points_y);
    free(centroids_x);
    free(centroids_y);
    free(point_assignments);

    return 0;
}
