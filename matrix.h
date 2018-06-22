/*..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
 *
 * This file is part of the Matrix-Multiplicator distribution Copyright (c) 2016
 * Jimmy Aguilar Mena.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Header in C for the simple Matrix-Matrix multiplication with time measurer.
 * Copyright 2016 Jimmy Aguilar Mena <kratsbinovish@gmail.com>
 *
 *..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..*/

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

    void mult_uncached(double* a,
                       double* b,
                       double* c,
                       const int dim);
    
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
