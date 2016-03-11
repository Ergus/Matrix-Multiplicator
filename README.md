# README

Simple code examples developed by **MSc. Jimmy Aguilar Mena** to test different square matrix-matrix multiplications.

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
| normal   | 1000 	   | 1.928310 |
| cached   | 1000	   | 0.558002 |
| blas	   | 1000	   | 0.765381 |
| fortran  | 1000	   | 0.589957 |
| asm	   | 1000	   | 0.484899 |
| omp	   | 1000	   | 0.263075 |


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
