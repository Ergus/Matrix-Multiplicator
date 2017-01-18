#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
#
# Matrix-Matrix multiplication Makefile example
# Copyright 2016 Jimmy Aguilar Mena <spacibba@yandex.com>
#
#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..

# Compiler
CC:= gcc
FC:= gfortran
CFL:= -O3
LIBS:=-L. -lblas -fopenmp -lpthread

# Produced files
all: main_gcc.x main_clang.x libmatrix_gcc.so libmatrix_clang.so

# Compile the application executable
main_gcc.x: main.cc libmatrix_gcc.so 
	$(CC) $(CFL) $< -o $@ $(LIBS) -lmatrix_gcc -Wl,-rpath,.

# Compile the application executable
main_clang.x: main.cc libmatrix_clang.so 
	clang $(CFL) $< -o $@ $(LIBS) -lmatrix_clang -Wl,-rpath,.

# Compile the shared library
libmatrix_gcc.so: matrix_gcc.o matrix_f.o matrix_asm.o
	$(CC) $(CFL) -shared $^ -o $@ $(LIBS)

# Compile the llvm shared library
libmatrix_clang.so: matrix_clang.o matrix_f.o matrix_asm.o
	clang $(CFL) -shared $^ -o $@ $(LIBS) 

# Compile the .o object from F90 and C
matrix_gcc.o: matrix.cc
	$(CC) $(CFL) -fPIC -c $< -o $@ -fopenmp

matrix_clang.o: matrix.cc
	clang $(CFL) -fPIC -c $< -o $@ -fopenmp

%.o: %.f90
	$(FC) $(CFL) -fPIC -c $< -o $@

%.o: %.asm
	nasm -f elf64 $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o

# define a make test command
test: main_gcc.x main_clang.x main.py
	@echo -e "\n====== Run GCC main ====="
	./$(word 1,$^) 100
	@echo -e "\n====== Run CLANG main ====="
	./$(word 2,$^) 100
	@echo -e "\n==== Run Python main =="
	./$(word 3,$^) 100
