#include "matrix.h"

void mult_cached(double* __restrict__ a,
                 double* __restrict__ b,
                 double* __restrict__ c,
                 const int dim){
    
    for(int i=0;i<dim;++i){
        const int idim=i*dim;
        for(int j=0;j<dim;j++){
            const int jdim=j*dim;
            const double temp=a[idim+j];
            for(int k=0;k<dim;k++){
                c[idim+k]+=(temp*b[jdim+k]);
                }
            }
        }
    }

void mult_blas(double *a,double *b,double *c, const int dim){
    char TransA[]={'N'};
    char TransB[]={'N'};
        
    int M=dim; int N=dim; int K=dim;
    int LDA=dim; int LDB=dim; int LDC=dim;
    double Alpha=1.0; double Betha=1.0;

    dgemm_(TransA, TransB,
           &M, &N, &K,
           &Alpha, b, &LDA,
           a, &LDB,
           &Betha, c, &LDC);
    }


// Other useful functions
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
