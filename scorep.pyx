# Python bindings of SCOREP library
# For MPI profiling to work, this MUST be imported before MPI.
cimport scorep_user as user
cimport scorep_internals as internals
from libc.stdint cimport uintptr_t
import atexit

cdef dlopen_libscorep(name):
    """
    Ensure the library NAME is dlopen'd and its symbols resolved.

    Necessary to intercept MPI profiling interface at the right time.
    """
    cdef void *handle = NULL
    cdef int mode = internals.RTLD_NOW | internals.RTLD_GLOBAL
    cdef char *libname = name
    handle = internals.dlopen(libname, mode)
    if handle is NULL:
        raise RuntimeError(
            "Unable to force loading of %s is it in LD_LIBRARY_PATH?" % name)

def initialize():
    """Initialize the measurement system"""
    dlopen_libscorep("libscorep_mpi.so")
    internals.SCOREP_InitMeasurement()

@atexit.register
def finalize():
    """Finalize the measurement system"""
    internals.SCOREP_FinalizeMeasurement()

# Cache of user-defined region handles.
_region_handles = dict()

cdef user.SCOREP_SourceFileHandle last_file_handle = 0
cdef char *last_file_name = NULL

def region_begin(name):
    """Start recording a region marked by NAME"""
    cdef user.SCOREP_User_RegionHandle handle
    cdef char *c_name = name
    cdef user.SCOREP_User_RegionType c_type

    # We should take an argument that decides what type to use
    c_type = user.SCOREP_USER_REGION_TYPE_COMMON

    h = _region_handles.get(name)
    if h:
        # Convert the cached value into a handle
        handle = <user.SCOREP_User_RegionHandle><uintptr_t>h
    else:
        handle = user.SCOREP_USER_INVALID_REGION
    # Actually register the region beginning
    user.SCOREP_User_RegionBegin(&handle, &last_file_name,
                                 &last_file_handle,
                                 c_name, c_type,
                                 "test.py", 1)
    # Map the handle back into something we can cache
    _region_handles[name] = <uintptr_t>handle

def region_end(name):
    """Finish recording the region denoted by NAME"""
    cdef user.SCOREP_User_RegionHandle handle
    h = _region_handles.get(name)
    if h:
        # Handle should be in the cache
        handle = <user.SCOREP_User_RegionHandle><uintptr_t>h
    else:
        # region_end without matching region_begin
        raise RuntimeError("Could not find handle for region %s" % name)

    user.SCOREP_User_RegionEnd(handle)

# Run initialization routine on module import
initialize()