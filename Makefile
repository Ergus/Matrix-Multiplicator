# Compiler
CC:= gcc
CFL:= -O3
LIBS:=-L. -lgslcblas -llapack -lblas

# Produced files
all: main.x libmatrix.so libmatrix_f.so

# Compile the application executable
main.x: main.cc libmatrix.so libmatrix_f.so
	$(CC) $(CFL) $< -o $@ $(LIBS) -lmatrix -lmatrix_f -Wl,-rpath,${PWD}

# Compile the shared library
libmatrix.so: matrix.o
	$(CC) $(CFL) -shared $^ -o $@ $(LIBS)

libmatrix_f.so: matrix_f.f90
	gfortran -O3 -shared -fPIC $< -o $@

# Compile the .o object
%.o: %.cc
	$(CC) $(CFL) -fPIC -c $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o

test: main.x
	./$< 100
