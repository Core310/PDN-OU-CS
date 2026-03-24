all: make_parallel

make_parallel: kmeans_clustering.c
	gcc -fopenmp -O3 -Wall -o kmeans_clustering kmeans_clustering.c -lm -std=c99

clean:
	$(RM) kmeans_clustering
