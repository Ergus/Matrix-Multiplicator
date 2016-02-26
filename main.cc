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
    double *a, *b, *c1, *c2, *c3, *c4, *c5;  // Arrays
    double t1,t2;             // Time variables

    if(argc==1){
        printf("Usage ./executable dim1 dim2 ...\n");
        return(-1);
        }
    
    for(int i=1;i<argc;i++){
        const int dim=atoi(argv[i]);
        const int size=dim*dim;

        // Allocate the memory for arrays
        a=(double*)malloc(size*sizeof(double));
        b=(double*)malloc(size*sizeof(double));
        
        c1=(double*)calloc(size,sizeof(double));
        c2=(double*)calloc(size,sizeof(double));
        c3=(double*)calloc(size,sizeof(double));
        c4=(double*)calloc(size,sizeof(double));
        c5=(double*)calloc(size,sizeof(double));

        // Fill the matrices with random numbes
        randfill(a,dim);
        randfill(b,dim);

        // Multiply using the normal algorithm
        t1=mtime();
        matmult1(a,b,c1,dim);
        t2=mtime();
        printf("simple\t dim: %4d\t time: %lf\n",dim,t2-t1);

        // Multiply with buffered algorithm
        t1=mtime();
        matmult2(a,b,c2,dim);
        t2=mtime();
        printf("buffer\t dim: %4d\t time: %lf\n",dim,t2-t1);

        // Multiply with blas
        t1=mtime();
        matmult3(a,b,c3,dim);
        t2=mtime();
        printf("c_blas\t dim: %4d\t time: %lf\n",dim,t2-t1);

        t1=mtime();
        matmult4(a,b,c4,dim);
        t2=mtime();
        printf("blas_\t dim: %4d\t time: %lf\n",dim,t2-t1);

        t1=mtime();
        int ldim=dim;
        matmult5_(a,b,c5,&ldim);
        t2=mtime();
        printf("fort\t dim: %4d\t time: %lf\n",dim,t2-t1);                 

        // Check that both results match
        bool equal=compare(c1,c2,dim);        
        printf("buffer\t %s\n",(equal?"match":"error"));

        equal=compare(c1,c3,dim);        
        printf("c_blas\t %s\n",(equal?"match":"error"));

        equal=compare(c1,c4,dim);        
        printf("blas_\t %s\n",(equal?"match":"error"));

        equal=compare(c1,c5,dim);        
        printf("fort\t %s\n",(equal?"match":"error")); 

        // Deallocate memory
        free(a);
        free(b);
        free(c1);
        free(c2);
        free(c3);
        free(c4);
        free(c5);
        }
    
    return 0;
    }
