# Simple example demonstrating scorep usage from python
import scorep
from mpi4py import MPI
c = MPI.COMM_WORLD


def inner():
    scorep.region_begin('inner')

    tmp = 1
    c.Barrier()    
    for i in xrange(100):
        tmp *= (i+1)

    scorep.region_end('inner')

def outer():
    scorep.region_begin('outer')
    c.Barrier()    
    for i in xrange(100):
        inner()
    scorep.region_end('outer')

outer()
