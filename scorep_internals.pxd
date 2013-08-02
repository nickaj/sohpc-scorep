# Internal SCOREP functionality.
# In the serial case, we must call InitMeasurement by hand
# FinalizeMeasurement is called with an atexit handler.
cdef extern from "SCOREP_RuntimeManagement.h":
    void SCOREP_InitMeasurement()
    void SCOREP_FinalizeMeasurement()

# Expose necessary dlopen functionality to force immediate loading of
# MPI-based scorep libraries
cdef extern from "dlfcn.h":
    void * dlopen(char *, int)
    int RTLD_NOW
    int RTLD_GLOBAL
    int RTLD_NOLOAD
