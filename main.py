#!/usr/bin/env python

import numpy as np
import ctypes as C
import sys
import time

# Open the C Library
lib=C.CDLL("./libmatrix.so")

lib.matmult1.restype=None
lib.matmult1.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    C.c_int]

lib.matmult2.restype=None
lib.matmult2.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    C.c_int]

lib.matmult3.restype=None
lib.matmult3.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    C.c_int]

lib.compare.restype=C.c_bool
lib.compare.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       C.c_int]
                     
def matmult0(a,b,c,dim):
    for i in range(dim):
        for j in range(dim):
            c[i,j]=0.0;
            for k in range(dim):
                c[i,j]+=(a[i,k]*b[k,j]);


if len(sys.argv)==1:
    print("Usage ./executable.py dim1 dim2 ...")
    quit()

for dim in sys.argv[1:]:
    idim= int(dim)
    a=np.random.random((idim,idim))
    b=np.random.random((idim,idim))
    c0=np.zeros((idim,idim))
    c1=np.zeros((idim,idim))
    c2=np.zeros((idim,idim))
    c3=np.zeros((idim,idim))
    c4=np.zeros((idim,idim))

    start = time.time()
    matmult0(a,b,c0,idim)
    end = time.time()
    print("mult0 dim: %d t: %f" % (idim,end-start))
    
    start = time.time()
    lib.matmult1(a,b,c1,idim)
    end = time.time()
    print("mult1 dim: %d t: %f" % (idim,end-start))

    start = time.time()
    lib.matmult2(a,b,c2,idim)
    end = time.time()
    print("mult2 dim: %d t: %f" % (idim,end-start))

    start = time.time()
    lib.matmult3(a,b,c3,idim)
    end = time.time()
    print("mult3 dim: %d t: %f" % (idim,end-start))

    start = time.time()
    c4=np.dot(a,b)
    end = time.time()
    print("mult4 dim: %d t: %f" % (idim,end-start))    
    
    print((c0==c1).all())
    print((c0==c2).all())
    print((c0==c3).all())
    print((c0==c4).all())
