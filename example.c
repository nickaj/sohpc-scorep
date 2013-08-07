#include <stdio.h>
#include "mpi.h"

double t1,t2,t3,t4,t,time;
int i,rank;

void inner()
{
  t1=MPI_Wtime();
  int tmp=1;
  MPI_Barrier(MPI_COMM_WORLD);
  for (i=1;i<100;i++){
    tmp *=(i+1);
  }
  t2=MPI_Wtime();
}

void outer()
{
  t3=MPI_Wtime();
  MPI_Barrier(MPI_COMM_WORLD);

  for (i=1;i<100;i++){ 
    inner();
  }
  t4=MPI_Wtime();
     
}

int main(int argc, char *argv[])
{
  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank); 
  t=MPI_Wtime();

  outer();

  MPI_Barrier(MPI_COMM_WORLD);
  time=MPI_Wtime();
  MPI_Finalize();
   
  printf("rank %d\n inner %f outer %f total %f\n",rank,t2-t1,t4-t3,time-t);
}
      
