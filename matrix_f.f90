

SUBROUTINE matmult5(a,b,c,dim)
  implicit none
  INTEGER dim
  DOUBLE PRECISION a(dim,dim),b(dim,dim),c(dim,dim)
  INTEGER i,j,k
  DOUBLE PRECISION temp

  DO k = 1,dim
     DO j = 1,dim
        temp = a(j,k)
        DO i = 1,dim
           c(i,k) = c(i,k) + temp*b(i,j)
        END DO
     END DO
  END DO

END SUBROUTINE matmult5
