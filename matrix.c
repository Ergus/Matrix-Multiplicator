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
 * Main code in C for the simple Matrix-Matrix multiplication with time measurer.
 * Copyright 2016 Jimmy Aguilar Mena <kratsbinovish@gmail.com>
 *
 *..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..*/

#include "matrix.h"

void mult_uncached(double* a, double* b, double* c, const int dim)
{
	for (int i=0, idim=0; i < dim; i++, idim += dim) {
		for (int j = 0; j < dim; j++){
			double tmp = 0.0;
			for(int k=0; k < dim; k++)
				tmp += (a[idim+k]*b[k*dim+j]);
			c[idim+j] = tmp;
		}
	}
}

void mult_cached(double* __restrict__ a, double* __restrict__ b,
                 double* __restrict__ c, const int dim)
{
	const int size = dim * dim;
	for(int idim = 0; idim < size; idim += dim) {
		for(int j = 0, jdim = 0; j < dim; j++, jdim += dim) {
			const double temp = a[idim+j];
			for(int k = 0; k < dim; k++) {
				c[idim + k] += (temp * b[jdim + k]);
			}
		}
	}
}

void mult_parallel(double* __restrict__ a, double* __restrict__ b,
                   double* __restrict__ c, const int dim)
{
	#pragma omp parallel for
	for (int i = 0; i < dim; ++i) {
		const int idim = i * dim;
		for(int j = 0; j < dim; j++){
			const int jdim = j * dim;
			const double temp = a[idim + j];
			for(int k = 0; k < dim; k++) {
				c[idim + k] += (temp * b[jdim + k]);
			}
		}
	}
}

void mult_blas(double *a, double *b, double *c, const int dim)
{
	char TransA[]={'N'};
	char TransB[]={'N'};

	int M=dim; int N=dim; int K=dim;
	int LDA=dim; int LDB=dim; int LDC=dim;
	double Alpha=1.0; double Betha=1.0;

	dgemm_(TransA, TransB,
	       &M, &N, &K,
	       &Alpha, b, &LDA,
	       a, &LDB,
	       &Betha, c, &LDC);
}


// Other useful functions
const char *compare(double *a, double *b, const int dim)
{
	const int size=dim*dim;
	for(int i=0;i<size;i++){
		if(a[i]!=b[i]) return "Error";
	}
	return "OK";
}

void randfill(double *a, const int dim)
{
	const int size = dim * dim;
	for(int i = 0; i < size; i++)
		a[i] = frand();
}


void printmat(double *a, const int dim)
{
	printf("\n ");
	for(int i = 0; i < dim; ++i){
		printf("| ");
		for(int j = 0; j < dim; j++){
			printf("%lf ",a[i * dim + j]);
		}
		printf("|\n ");
	}
	printf("\n ");
}
