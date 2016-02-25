#include "matrix.h"

void printmat(double *a, const int dim){
    printf("\n ");    
    for(int i=0;i<dim;++i){
        printf("| ");
        for(int j=0;j<dim;j++){
            printf("%lf ",a[i*dim+j]);
            }
        printf("|\n ");
        }
    printf("\n ");
    }

void matmult1(double *a,double *b,double *c,const int dim){  
    for(int i=0;i<dim;++i){
        for(int j=0;j<dim;j++){            
            c[i*dim+j]=0.0;
            for(int k=0;k<dim;k++){
                c[i*dim+j]+=(a[i*dim+k]*b[k*dim+j]);
                }
            }
        }
    }

void matmult2(double *a,double *b,double *c,const int dim){
    
    double* tmp=(double*)malloc(sizeof(double)*dim);
    for(int j=0;j<dim;++j){
        double cum=0.0;
        for(int k=0;k<dim;++k){
            const double var=b[k*dim+j];
            cum+=(a[k]*var);         
            tmp[k]=var;
            }
        c[j]=cum;

        int idim=dim;
        for(int i=1;i<dim;++i,idim+=dim){
            double cum=0.0;
            for(int k=0;k<dim;++k){
                cum+=(a[idim+k]*tmp[k]);
                }
            c[idim+j]=cum;
            }
        }
    free(tmp);
    }

void matmult3(double *a,double *b,double *c, const int dim){
    
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                dim, dim, dim, 1.0, a, dim, b, dim, 1.0, c, dim);
    }


bool compare(double *a, double *b, const int dim){
    const int size=dim*dim;
    for(int i=0;i<size;i++){
        if(a[i]!=b[i]) return false;
        }
    return true;
    }

void randfill(double *a, const int dim){
    const int size=dim*dim;
    for(int i=0;i<size;i++){
        a[i]=frand();
        }
    }

