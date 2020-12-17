// ----------- Arqo P4-----------------------
// pescalar_serie
//

#include <stdio.h>
#include <stdlib.h>
#include "arqo4.h"

int main(int argc, char **argv)
{
	float *A=NULL, *B=NULL;
	long long k=0;
  long long __size = 0;
	struct timeval fin,ini;
	double sum=0;

  if(argc < 2)
    __size = M;
  else
    __size = atoi(argv[1]);

  printf("@@@@@@@ %s\n", argv[1]);
	
	A = generateVectorOne(__size);
	B = generateVectorOne(__size);
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	}
	
	gettimeofday(&ini,NULL);
	/* Bloque de computo */
	sum = 0;
	for(k=0;k<__size;k++)
	{
		sum = sum + A[k]*B[k];
	}
	/* Fin del computo */
	gettimeofday(&fin,NULL);

	printf("\nresult: %f\n",sum);
	printf("time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}
