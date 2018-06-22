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

#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/time.h>

#include "matrix.h"

double mtime()
{	  //Time measurer
	struct timeval tmp;
	double sec;
	gettimeofday( &tmp, (struct timezone *)0 );
	sec = tmp.tv_sec + ((double)tmp.tv_usec)/1000000.0;
	return sec;
}

int main(int argc, char** argv)
{
	double *a, *b, *c0, *c1, *c2, *c3, *c4, *c5;  // Arrays
	double t1,t2;             // Time variables

	if (argc == 1) {
		printf("Usage ./executable dim1 dim2 ...\n");
		return(-1);
	}

	for(int i = 1; i < argc; ++i) {
		const int dim=atoi(argv[i]);
		const int size=dim*dim;

		// Allocate the memory for arrays
		a = (double*) malloc(size * sizeof(double));
		b = (double*) malloc(size * sizeof(double));

		c0 = (double*) calloc(size, sizeof(double));
		c1 = (double*) calloc(size, sizeof(double));
		c2 = (double*) calloc(size, sizeof(double));
		c3 = (double*) calloc(size, sizeof(double));
		c4 = (double*) calloc(size, sizeof(double));
		c5 = (double*) calloc(size, sizeof(double));

		// Fill the matrices with random numbes
		randfill(a,dim);
		randfill(b,dim);

		// Multiply using the normal algorithm
		t1=mtime();
		mult_uncached(a, b, c0, dim);
		t2=mtime();
		printf("normal\t dim: %4d\t time: %lf\n", dim, t2 - t1);

		// Multiply using the cached algorithm
		t1=mtime();
		mult_cached(a, b, c1, dim);
		t2=mtime();
		printf("cached\t dim: %4d\t time: %lf\t match: %s\n",
		       dim, t2 - t1, compare(c0, c1, dim));

		// Multiply with buffered algorithm
		t1=mtime();
		mult_blas(a, b, c2, dim);
		t2=mtime();
		printf("blas\t dim: %4d\t time: %lf\t match: %s\n",
		       dim, t2 - t1, compare(c0, c2, dim));

		// Multiply with blas
		t1=mtime();
		int ldim=dim;
		mult_fort_(a, b, c3, &ldim);
		t2=mtime();
		printf("fortran\t dim: %4d\t time: %lf\t match: %s\n",
		       dim, t2 - t1, compare(c0, c3, dim));

		// Multiply in assembler
		t1=mtime();
		mult_asm(a, b, c4, dim);
		t2=mtime();
		printf("asm\t dim: %4d\t time: %lf\t match: %s\n",
		       dim, t2 - t1, compare(c0, c4, dim));

		// Multiply with buffered algorithm and OpenMP
		t1=mtime();
		mult_parallel(a, b, c5, dim);
		t2=mtime();
		printf("omp\t dim: %4d\t time: %lf\t match: %s\n",
		       dim, t2 - t1, compare(c0, c5, dim));

		// Deallocate memory
		free(a);
		free(b);
		free(c0);
		free(c1);
		free(c2);
		free(c3);
		free(c4);
		free(c5);
	}

	return 0;
}
