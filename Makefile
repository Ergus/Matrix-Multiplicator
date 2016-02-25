# Compiler
CC:= gcc
CFL:= -O3
LIBS:=-lgslcblas

# Produced files
all: main.x libmatrix.so

# Compile the application executable
main.x: main.cc libmatrix.so
	$(CC) $(CFL) -L. $< -o $@ $(LIBS) -lmatrix -Wl,-rpath,${PWD}

# Compile the shared library
libmatrix.so: matrix.o
	$(CC) $(CFL) -shared $^ -o $@ $(LIBS)

# Compile the .o object
%.o: %.cc
	$(CC) $(CFL) -fPIC -c $< -o $@

.PHONY: clean test

# Clean and delete all the generated files.
clean:
	rm -rf *.x *.so *.o

test: main.x
	./$< 100
