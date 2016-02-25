#include <stdio.h>
#include <stdlib.h>

//#include <time.h>
//#include <ctype.h>
#include <sys/types.h>
#include <sys/time.h>

#include "matrix.h"

double mtime(){	  //Time measurer
    struct timeval tmp;
    double sec;
    gettimeofday( &tmp, (struct timezone *)0 );
    sec = tmp.tv_sec + ((double)tmp.tv_usec)/1000000.0;
    return sec;
    }

int main(int argc, char** argv){
    double *a, *b, *c1, *c2, *c3;  // Arrays
    double t1,t2;             // Time variables

    if(argc==1){
        printf("Usage ./executable dim1 dim2 ...\n");
        return(-1);
        }
    
    for(int i=1;i<argc;i++){
        const int dim=atoi(argv[i]);
        const int size=dim*dim*sizeof(double);

        // Allocate the memory for arrays
        a=(double*)malloc(size);
        b=(double*)malloc(size);
        c1=(double*)malloc(size);
        c2=(double*)malloc(size);
        c3=(double*)malloc(size);

        // Fill the matrices with random numbes
        randfill(a,dim);
        randfill(b,dim);

        #ifdef DEBUG
        printmat(a,dim);
        printmat(b,dim);
        #endif
        
        // Multiply using the normal algorithm
        t1=mtime();
        matmult1(a,b,c1,dim);
        t2=mtime();
        printf("mult1 dim: %4d time: %lf\n",dim,t2-t1);

        // Multiply with buffered algorithm
        t1=mtime();
        matmult2(a,b,c2,dim);
        t2=mtime();
        printf("mult2 dim: %4d time: %lf\n",dim,t2-t1);

        // Multiply with blas
        t1=mtime();
        matmult3(a,b,c3,dim);
        t2=mtime();
        printf("mult2 dim: %4d time: %lf\n",dim,t2-t1);        

        // Check that both results match
        bool equal=compare(c1,c2,dim);        
        printf("Buff %s\n",(equal?"Iguales":"Desiguales"));

        equal=compare(c1,c3,dim);        
        printf("Blas %s\n",(equal?"Iguales":"Desiguales"));

        // Deallocate memory
        free(a);
        free(b);
        free(c1);
        free(c2);
        free(c3);
        }
    
    return 0;
    }
