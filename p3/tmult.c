//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

int main( int argc, char *argv[])
{
	int n;
	tipo **a=NULL, **b=NULL, **c=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if ( argc!=2 ) {
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n = atoi(argv[1]);

	a = generateMatrix(n);
	b = generateMatrix(n);
  c = generateEmptyMatrix(n);

	gettimeofday(&ini,NULL);
	/* Main computation */
  t( b, n );
	tmult(a,b,c,n);
	/* End of computation */
	gettimeofday(&fin,NULL);
  
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
  
	free(a);
	free(b);
	free(c);

	return 0;
}