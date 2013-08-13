# Simple example demonstrating scorep usage from python
#with more functions available

import scorep
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

def example():
    d = 2356

    scorep.region_begin('example')

    comm.send(d,dest=(rank+1)%size)
    data=comm.recv(source=(rank-1)%size)

    scorep.enable_recording()

    comm.send(d,dest=(rank+1)%size)
    data=comm.recv(source=(rank-1)%size)

    scorep.disable_recording()

    scorep.region_end('example')
    print data

example()
