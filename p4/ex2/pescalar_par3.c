// ----------- Arqo P4-----------------------
// pescalar_par1
// ¿Funciona correctamente?
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "arqo4.h"

#define _THRESHOLD_ 50000

int main(int argc, char **argv)
{
	int nproc;
	float *A=NULL, *B=NULL;
	long long k=0;
  long long __size = 0;
  int _nthreads;
	struct timeval fin,ini;
	double sum=0;

  if (argc == 1)
  {
    __size = M;
    nproc = omp_get_num_procs();
    omp_set_num_threads(nproc);
  }
  else
  {
    _nthreads = atoi(argv[1]);
    omp_set_num_threads(_nthreads);
    if (argc > 2)
      __size = atoi(argv[2]);
    else
      __size = M;
  }
  
       
	A = generateVectorOne(__size);
	B = generateVectorOne(__size);
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	} 
  
  printf("Se han lanzado %d hilos.\n", _nthreads);

	gettimeofday(&ini,NULL);
	/* Bloque de computo */
	sum = 0;
	
  #pragma omp parallel for reduction(+:sum)   if(__size>_THRESHOLD_)
	for(k=0;k<__size;k++)
	{
		sum = sum + A[k]*B[k];
	}
	/* Fin del computo */
	gettimeofday(&fin,NULL);

	printf("result: %f\n",sum);
	printf("time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}
