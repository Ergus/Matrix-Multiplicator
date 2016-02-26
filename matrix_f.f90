

SUBROUTINE matmult(a,b,c,dim)
  implicit none
  INTEGER dim
  DOUBLE PRECISION a(dim,dim),b(dim,dim),c(dim,dim)
  INTEGER i,j,k
  DOUBLE PRECISION temp, temp2
  DOUBLE PRECISION, ALLOCATABLE, DIMENSION(:) :: buff

  ALLOCATE(buff(dim))

  DO i=1,dim
     temp=0.0
     DO k=1,dim
        temp2 = b(i,k)
        buff(k) = temp2
        temp=temp+(a(k,1)*temp2)
     END DO
     c(i,1)=temp
     
     DO j=2,dim
        temp=0.0
        DO k=1,dim
           temp=temp+(a(k,j)*buff(k))
        END DO
        c(i,j)=temp
     END DO
  END DO

  DEALLOCATE(buff)  

END SUBROUTINE matmult
