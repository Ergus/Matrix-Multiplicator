#!/usr/bin/env python2

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

lib.matmult4.restype=None
lib.matmult4.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                    np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
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
    c5=np.zeros((idim,idim))

    start = time.time()
    matmult0(a,b,c0,idim)
    end = time.time()
    print("loop dim: %d t: %f" % (idim,end-start))
    
    start = time.time()
    lib.matmult1(a,b,c1,idim)
    end = time.time()
    print("simple dim: %d t: %f" % (idim,end-start))

    start = time.time()
    lib.matmult2(a,b,c2,idim)
    end = time.time()
    print("buffer dim: %d t: %f" % (idim,end-start))

    start = time.time()
    lib.matmult3(a,b,c3,idim)
    end = time.time()
    print("c_blas dim: %d t: %f" % (idim,end-start))

    start = time.time()
    lib.matmult4(a,b,c4,idim)
    end = time.time()
    print("blas_ dim: %d t: %f" % (idim,end-start))    

    start = time.time()
    c5=np.dot(a,b)
    end = time.time()
    print("numpy dim: %d t: %f" % (idim,end-start))
    
    print((c0==c1).all())
    print((c0==c2).all())
    print((c0==c3).all())
    print((c0==c4).all())
    print((c0==c5).all())
