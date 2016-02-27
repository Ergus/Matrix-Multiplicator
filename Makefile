# Compiler
CC:= gcc
FC:= gfortran
CFL:= -O3
LIBS:=-L. -lblas -fopenmp -lpthread

# Produced files
all: main.x libmatrix.so

# Compile the application executable
main.x: main.cc libmatrix.so matrix_asm.o
	$(CC) $(CFL) $< matrix_asm.o -o $@ $(LIBS) -lmatrix -Wl,-rpath,.

# Compile the shared library
libmatrix.so: matrix_f.o matrix.o 
	$(CC) $(CFL) -shared $^ -o $@ $(LIBS) 

# Compile the .o object from F90 and C
%.o: %.cc
	$(CC) $(CFL) -fPIC -c $< -o $@ -fopenmp

%.o: %.f90
	$(FC) $(CFL) -fPIC -c $< -o $@

%.o: %.asm
	nasm -f elf64 $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o

# define a make test command
test: main.x main.py
	@echo -e "\n====== Run C main ====="
	./$(word 1,$^) 100
	@echo -e "\n==== Run Python main =="
	./$(word 2,$^) 100
