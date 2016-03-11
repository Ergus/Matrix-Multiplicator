#!/usr/bin/env python2

#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
#
# Main code in python the simple Matrix-Matrix multiplication with time measurer.
# using CTypes.
# Copyright 2016 Jimmy Aguilar Mena <spacibba@yandex.com>
#
#..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..

import numpy as np
import ctypes as C
import sys
import time

# Open the C Library
lib=C.CDLL("./libmatrix.so")

lib.mult_cached.restype=None
lib.mult_cached.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       C.c_int]

lib.mult_parallel.restype=None
lib.mult_parallel.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       C.c_int]

lib.mult_blas.restype=None
lib.mult_blas.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                       C.c_int]

lib.mult_fort_.restype=None
lib.mult_fort_.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                        np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                        np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
                        C.POINTER(C.c_int)]

lib.mult_asm.restype=None
lib.mult_asm.argtypes=[np.ctypeslib.ndpointer(C.c_double, flags="C_CONTIGUOUS"),\
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

    # Total number of functions 6
    c0=np.zeros((idim,idim))
    c1=np.zeros((idim,idim))
    c2=np.zeros((idim,idim))
    c3=np.zeros((idim,idim))
    c4=np.zeros((idim,idim))
    c5=np.zeros((idim,idim))
    c6=np.zeros((idim,idim))

    start = time.time()
    matmult0(a,b,c0,idim)
    end = time.time()
    print("loop\t dim: %d\t t: %f" % (idim,end-start))
    
    start = time.time()
    lib.mult_cached(a,b,c1,idim)
    end = time.time()
    print("simple\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c1).all()))

    start = time.time()
    lib.mult_blas(a,b,c2,idim)
    end = time.time()
    print("blas\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c2).all()))

    start = time.time()
    lib.mult_fort_(a,b,c3,C.byref(C.c_int(idim)))
    end = time.time()
    print("fort\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c3).all()))

    start = time.time()
    c4=np.dot(a,b)
    end = time.time()
    print("numpy\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c4).all()))

    start = time.time()
    lib.mult_asm(a,b,c5,idim)
    end = time.time()
    print("asm\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c5).all()))    
    
    start = time.time()
    lib.mult_parallel(a,b,c6,idim)
    end = time.time()
    print("openMP\t dim: %d\t t: %f match: %r" % (idim,end-start,(c0==c6).all()))
