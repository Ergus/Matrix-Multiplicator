# README

Simple code examples developed to test different squared matrix-matrix
multiplications.

Simple example code for square matrix multiplication in C, Fortran, Assembler
and Python.

All the functions are compiled in a shared library. Python and C call all the
functions included in the shared library. Python also uses Numpy and a python
loop extra function.

The fortran method is called directly using the old Fortran method.

The only external dependencies are blass and numpy. All the codes are optimized
based on the original BLAS routine.

The Assembler Implementation have vectorization with ymm 256 bit registers, so
the mult_asm code should work only for dim%4==0.

To compile, gcc, gfortran and nasm are needed.

## Run GCC main

./main_gcc.x 1000

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|normal    | 1000      | 2.017361 |
|cached    | 1000      | 0.584735 |
|blas      | 1000      | 0.754343 |
|fortran   | 1000      | 0.586900 |
|asm       | 1000      | 0.441710 |
|omp       | 1000      | 0.576689 |

## Run CLANG main

./main_clang.x 1000

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|normal    | 1000      | 1.997429 |
|cached    | 1000      | 0.550460 |
|blas      | 1000      | 0.752818 |
|fortran   | 1000      | 0.583280 |
|asm       | 1000      | 0.441788 |
|omp       | 1000      | 0.334884 |

## Run Python main

./main.py 100

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|loop      | 100       | 0.635916 |
|simple    | 100       | 0.000585 |
|blas      | 100       | 0.000824 |
|fort      | 100       | 0.000552 |
|numpy     | 100       | 0.000834 |
|asm       | 100       | 0.000217 |
|openMP    | 100       | 0.017425 |

