#ifndef MATRIX_H
#define MATRIX_H

#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_cblas.h>

#define frand()((double)rand()/(RAND_MAX))

#ifdef __cplusplus
extern "C"{
#endif //__cplusplus

    void dgemm_(char*,char*,
                int*,int*,int*,
                double*,double*,int*,
                        double*,int*,
                double*,double*,int*);

    void matmult1(double* __restrict__ a,
                  double* __restrict__ b,
                  double* __restrict__ c,
                  const int dim);
    
    void matmult2(double *a,double *b,double *c,const int dim);
    void matmult3(double *a,double *b,double *c,const int dim);
    void matmult4(double *a,double *b,double *c,const int dim);
    void matmult5_(double *,double* ,double*,int* );    
    
    bool compare(double *a, double *b, const int dim);

    void randfill(double *a, const int dim);

    void printmat(double *a, const int dim);
        
#ifdef __cplusplus
}
#endif //__cplusplus

#endif //MATRIX_H
