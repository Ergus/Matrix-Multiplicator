#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
#
# This file is part of the Matrix-Multiplicator distribution Copyright (c) 2016
# Jimmy Aguilar Mena.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Makefile for the simple Matrix-Matrix multiplication with time measurer.
# Copyright 2016 Jimmy Aguilar Mena <kratsbinovish@gmail.com>
#
#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..

# Compiler
CC:= gcc
FC:= gfortran
CFL:= -O3 -g
GFL:= -O3 -g
LIBS:=-L. -lblas -fopenmp -lpthread

# Produced files
all: main_gcc.x main_clang.x libmatrix_gcc.so libmatrix_clang.so

# Compile the application executable
main_gcc.x: main.c libmatrix_gcc.so
	$(CC) $(GFL) $< -o $@ $(LIBS) -lmatrix_gcc -Wl,-rpath,.

# Compile the application executable
main_clang.x: main.c libmatrix_clang.so
	clang $(CFL) $< -o $@ $(LIBS) -lmatrix_clang -Wl,-rpath,.

# Compile the shared library
libmatrix_gcc.so: matrix_gcc.o matrix_f.o matrix_asm.o
	$(CC) $(GFL) -shared $^ -o $@ $(LIBS)

# Compile the llvm shared library
libmatrix_clang.so: matrix_clang.o matrix_f.o matrix_asm.o
	clang $(CFL) -shared $^ -o $@ $(LIBS)

# Compile the .o object from F90 and C
matrix_gcc.o: matrix.c
	$(CC) $(GFL) -fPIC -c $< -o $@ -fopenmp

matrix_clang.o: matrix.c
	clang $(CFL) -fPIC -c $< -o $@ -fopenmp

%.o: %.f90
	$(FC) $(GFL) -fPIC -c $< -o $@

%.o: %.asm
	nasm -f elf64 $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o *.out *.profile

# define a make test command
test: main_gcc.x main_clang.x main.py
	@echo -e "\n====== Run GCC main ====="
	./$(word 1,$^) 1000
	@echo -e "\n====== Run CLANG main ====="
	./$(word 2,$^) 1000
	@echo -e "\n==== Run Python main =="
	./$(word 3,$^) 100
