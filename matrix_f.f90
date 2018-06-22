 !..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
 !
 ! This file is part of the Matrix-Multiplicator distribution Copyright (c) 2016
 ! Jimmy Aguilar Mena.
 !
 ! This program is free software: you can redistribute it and/or modify
 ! it under the terms of the GNU General Public License as published by
 ! the Free Software Foundation, version 3.
 !
 ! This program is distributed in the hope that it will be useful, but
 ! WITHOUT ANY WARRANTY; without even the implied warranty of
 ! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 ! General Public License for more details.
 !
 ! You should have received a copy of the GNU General Public License
 ! along with this program. If not, see <http://www.gnu.org/licenses/>.
 !
 ! Main FORTRAN code for the simple Matrix-Matrix multiplication with time
 ! measurer. Copyright 2016 Jimmy Aguilar Mena <kratsbinovish@gmail.com>
 !
 !..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..*/

SUBROUTINE mult_fort(a,b,c,dim)
  implicit none
  INTEGER, INTENT(in) :: dim
  DOUBLE PRECISION, INTENT(IN) :: a(dim,dim),b(dim,dim)
  DOUBLE PRECISION, INTENT(OUT) :: c(dim,dim)
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

END SUBROUTINE mult_fort

