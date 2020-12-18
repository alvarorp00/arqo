//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

int main( int argc, char *argv[])
{
	int n, option, _nthreads;
	tipo **a=NULL, **b=NULL, **c=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if ( argc < 3 ) {
		printf("Error: %s <matrix size> <option [1,2,3,4]> <#hilos (si option > 1)>\n", argv[0]);
		return -1;
	}
	n = atoi(argv[1]);
  option = atoi(argv[2]);

  if (option > 1)
  {
    if ( argc != 4)
    {
      printf("Error: if option > 1, num_threads must be specified\n");
      return -1;
    }
    else
    {
      _nthreads = atoi(argv[3]);
    }
  }
    
	a = generateTypeMatrix(n);
	b = generateTypeMatrix(n);
  c = generateTypeEmptyMatrix(n);
	
	/* Main computation */
  switch (option)
  {
  case 1:
    printf("Selected: no parallel\n");
    gettimeofday(&ini,NULL);
    mult(a, b, c, n);
    gettimeofday(&fin,NULL);
    break;

  case 2:
    printf("Selected: Inner loop parallel\n");
    gettimeofday(&ini,NULL);
    omp1_mult(a, b, c, n, _nthreads);
    gettimeofday(&fin,NULL);
    break;

  case 3:
    printf("Selected: Middle loop parallel\n");
    gettimeofday(&ini,NULL);
    omp2_mult(a, b, c, n, _nthreads);
    gettimeofday(&fin,NULL);
    break;

  case 4:
    printf("Selected: Outer loop parallel\n");
    gettimeofday(&ini,NULL);
    omp3_mult(a, b, c, n, _nthreads);
    gettimeofday(&fin,NULL);
    break;
  
  default:
    printf("Error. <option> in [1, 2, 3, 4]\n");
    return 1;
  }
	/* End of computation */
  
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
  
	free(a);
	free(b);
	free(c);

	return 0;
}