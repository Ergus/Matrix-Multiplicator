# README

Simple code examples developed by **MSc. Jimmy Aguilar Mena** to test different square matrix-matrix multiplications.

Simple example code for square matrix multiplication in C, Fortran, Assembler and Python. 

All the functions are compiled in a shared library. Python and C call all the functions included in the shared library. Python 
also uses Numpy and a python loop extra function.

The fortran method is called directly using the old Fortran method.

The only external dependencies are blass and numpy. All the codes are optimized based on the original BLAS routine. 

The Assembler Implementation have vectorization with ymm 256 bit registers, so the mult_asm code should work only for dim%4==0.

To compile, gcc, gfortran and nasm are needed.

## Run GCC main

./main_gcc.x 1000

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|normal    | 1000      | 2.264107 |
|cached    | 1000      | 1.390773 |
|blas      | 1000      | 2.762676 |
|fortran   | 1000      | 1.394452 |
|asm       | 1000      | 0.394383 |
|omp       | 1000      | 0.460474 |

## Run CLANG main

./main_clang.x 1000

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|normal    | 1000      | 2.315583 |
|cached    | 1000      | 0.522179 |
|blas      | 1000      | 2.779882 |
|fortran   | 1000      | 1.401433 |
|asm       | 1000      | 0.393088 |
|omp       | 1000      | 0.305081 |

## Run Python main

./main.py 100

| Version  | Dimension |   Time   |
|----------|:---------:|:--------:|
|loop      | 100       | 0.495779 |
|simple    | 100       | 0.000496 |
|blas      | 100       | 0.000650 |
|fort      | 100       | 0.000468 |
|numpy     | 100       | 0.002736 |
|asm       | 100       | 0.000229 |
|openMP    | 100       | 0.014398 |
