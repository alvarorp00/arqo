//P3 arq 2019-2020
#ifndef _ARQO_P3_H_
#define _ARQO_P3_H_

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#if __x86_64__
	typedef double tipo;
#else
	typedef float tipo;
#endif

tipo ** generateTypeMatrix(int);
tipo ** generateTypeEmptyMatrix(int);
void freeTypeMatrix(tipo **);
void printMatrix( tipo **m, int n );
void t( tipo **a, int n );

/**
 * No parallel region
 */
void mult(tipo **a, tipo **b, tipo **c, int n);

/**
 * Parallel region in inner loop
 */
void omp1_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads);

/**
 * Parallel region in middle loop
 */
void omp2_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads);

/**
 * Parallel region in outer loop
 */
void omp3_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads);


void tmult(tipo **a, tipo **b, tipo **c, int n);

#endif /* _ARQO_P3_H_ */
