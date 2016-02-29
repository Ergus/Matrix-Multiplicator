# README

Simple example code for square matrix multiplication in C, Fortran, Assembler and Python. 

All the functions are compiled in a shared library. Python and C call all the functions included in the shared library. Python 
also uses Numpy and a python loop extra function.

The fortran method is called directly using the old Fortran method.

The only external dependencies are blass and numpy. All the codes are optimized based on the original BLAS routine. 

The Assembler Implementation have vectorization with ymm 256 bit registers, so the mult_asm code should work only for dim%4==0.

To compile, gcc, gfortran and nasm are needed.

./main.x 200

| Languaje | Dimension |   Time   |
|----------|:---------:|:--------:|
| cached   |  200  	   | 0.003969 |
| blas     |  200	   | 0.005722 |
| fortran  |  200	   | 0.003675 |
| asm	   |  200	   | 0.002260 |
| omp	   |  200	   | 0.003199 |


./main.py 200  

| Languaje | Dimension |   Time   |
|----------|:---------:|:--------:|
| loop     |   200	   | 4.303328 |
| simple   |   200	   | 0.003462 |
| blas     |   200	   | 0.005074 |
| fort     |   200	   | 0.003687 |
| numpy    |   200	   | 0.005062 |
| asm      |   200	   | 0.002292 |
| openMP   |   200	   | 0.006784 |
