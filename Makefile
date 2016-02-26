# Compiler
CC:= gcc
CFL:= -O3
LIBS:=-L. -lblas -lgslcblas

# Produced files
all: main.x libmatrix.so

# Compile the application executable
main.x: main.cc libmatrix.so
	$(CC) $(CFL) $< -o $@ $(LIBS) -lmatrix -Wl,-rpath,${PWD}

# Compile the shared library
libmatrix.so: matrix_f.o matrix.o 
	$(CC) $(CFL) -shared $^ -o $@ $(LIBS)

matrix_f.o: matrix_f.f90
	gfortran -O3 -fPIC -c $< -o $@

# Compile the .o object
%.o: %.cc
	$(CC) $(CFL) -fPIC -c $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o

test: main.x
	./$< 100
