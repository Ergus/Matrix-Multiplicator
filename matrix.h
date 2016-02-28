#ifndef MATRIX_H
#define MATRIX_H

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>


#define frand()((double)rand()/(RAND_MAX))

#ifdef __cplusplus
extern "C"{
#endif //__cplusplus

    // External function from blas
    void dgemm_(char*,char*,
                int*,int*,int*,
                double*,double*,int*,
                        double*,int*,
                double*,double*,int*);

    // Simple loop multiplication
    void mult_cached(double* __restrict__ a,
                     double* __restrict__ b,
                     double* __restrict__ c,
                     const int dim);

    void mult_parallel(double* __restrict__ a,
                       double* __restrict__ b,
                       double* __restrict__ c,
                       const int dim);    
    
    // Blass multiplication
    void mult_blas(double* ,double* ,double* ,const int);

    // Fortran multiplication
    void mult_fort_(double* ,double* ,double*, int* );

    void mult_asm(double* , double* , double* , int);

    // Other useful functions
    const char* compare(double *a, double *b, const int dim);
    void randfill(double *a, const int dim);
    void printmat(double *a, const int dim);
        
#ifdef __cplusplus
}
#endif //__cplusplus

#endif //MATRIX_H
