//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#include "arqo3.h"

tipo ** generateMatrix(int size);
void freeMatrix(tipo **matrix);

tipo ** generateTypeMatrix(int size)
{
	tipo *array=NULL;
	tipo **matrix=NULL;
	int i=0,j=0;

	matrix=(tipo **)malloc(sizeof(tipo *)*size);
	array=(tipo *)malloc(sizeof(tipo)*size*size);
	if( !array || !matrix)
	{
		printf("Error when allocating matrix of size %d.\n",size);
		if( array )
			free(array);
		if( matrix )
			free(matrix);
		return NULL;
	}

	srand(0);
	for(i=0;i<size;i++)
	{
		matrix[i] = &array[i*size];
		for(j=0;j<size;j++)
		{
			matrix[i][j] = (1.0*rand()) / (RAND_MAX/10);
		}
	}

	return matrix;
}

tipo ** generateTypeEmptyMatrix(int size)
{
	tipo *array=NULL;
	tipo **matrix=NULL;
	int i=0;

	matrix=(tipo **)malloc(sizeof(tipo *)*size);
	array=(tipo *)malloc(sizeof(tipo)*size*size);
	if( !array || !matrix)
	{
		printf("Error when allocating matrix of size %d.\n",size);
		if( array )
			free(array);
		if( matrix )
			free(matrix);
		return NULL;
	}

	for(i=0;i<size;i++)
	{
		matrix[i] = &array[i*size];
	}

	return matrix;
}

void printMatrix( tipo **m, int n ) {
	
  int i, j;

  for (i=0;i<n;i++ ) {
    for (j=0;j<n;j++) {
      printf( "%7.1lf", m[j][i] );
    }
    printf( "\n" );
	}
}


void t( tipo **a, int n ) {
  
  int i, j;
  tipo aux;
  
  for (i=0;i<n;i++ ) {
    for (j=0;j<i;j++) {
      aux = a[i][j];
      a[i][j] = a[j][i];
      a[j][i] = aux;
    }
	}
}

void mult(tipo **a, tipo **b, tipo **c, int n)
{

  tipo sum;
	int i, j, k;

  for (i=0;i<n;i++ ) {
    for (j=0;j<n;j++) {
      sum = 0;
      for (k=0;k<n;k++) {
        sum+=a[i][k] * b[k][j];
      }
      c[i][j] = sum;
    }
	}
}

void omp1_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads)
{

  tipo sum;
	int i, j, k;

  printf("Launching %d threads \n", _n_threads);

  omp_set_num_threads(_n_threads);

  for (i=0;i<n;i++ ) {
    for (j=0;j<n;j++) {
      sum = 0;
      #pragma omp parallel for reduction(+:sum)
      for (k=0;k<n;k++) {
        sum += a[i][k] * b[k][j];
      }
      c[i][j] = sum;
    }
	}
}

void omp2_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads)
{

  tipo sum;
	int i, j, k;

  printf("Launching %d threads \n", _n_threads);

  omp_set_num_threads(_n_threads);

  for (i=0;i<n;i++ ) {
    #pragma omp parallel for reduction(+:sum) private(j, k) shared(i, a, b, c)
    for (j=0;j<n;j++) {
      sum = 0;
      for (k=0;k<n;k++) {
        sum+=a[i][k] * b[k][j];
      }
      c[i][j] = sum;
    }
	}
}

void omp3_mult(tipo **a, tipo **b, tipo **c, int n, int _n_threads)
{

  tipo sum;
	int i, j, k;

  printf("Launching %d threads \n", _n_threads);

  omp_set_num_threads(_n_threads);

  sum = 0;

  #pragma omp parallel for reduction(+:sum) private(i, j, k) shared(a, b, c)
  for (i=0;i<n;i++ ) {
    for (j=0;j<n;j++) {
      sum = 0;
      for (k=0;k<n;k++) {
        sum+=a[i][k] * b[k][j];
      }
      c[i][j] = sum;
      }
    }
}

void tmult(tipo **a, tipo **b, tipo **c, int n) {

  tipo sum;
	int i, j, k;

  for (i=0;i<n;i++ ) {
    for (j=0;j<n;j++) {
      sum = 0;
      for (k=0;k<n;k++) {
        sum+=a[i][k] * b[j][k];
      }
      c[i][j] = sum;
    }
	}
}


void freeTypeMatrix(tipo **matrix) 
{
	if( matrix && matrix[0] )
		free(matrix[0]);
	if( matrix )
		free(matrix);
	return;
}
