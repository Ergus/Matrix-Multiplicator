# README

Simple example code for square matrix multiplication in C, Fortran, NASM and Python. Python and C call all the functions included in the library.

The Fortran and the C code are compiled in the same library and are called directly using the old Fortran method when needed.

The only external dependencies are blass and numpy. All the codes are optimized based on the original BLAS routine. 

The Assembler Implementation have vectorization with ymm 256 registers, so the mult_asm code should work only for dim%4==0.

To compile, gcc, gfortran and nasm are needed.


