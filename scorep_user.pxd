# Copyright (c) 2013 The University of Edinburgh.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



# Expose user-facing functionality from SCOREP to python
from libc.stdint cimport uint32_t, uint64_t
from cpython cimport bool

# Opaque handles
cdef extern from "scorep/SCOREP_PublicTypes.h":
    ctypedef uint32_t SCOREP_Allocator_MoveableMemory
    ctypedef SCOREP_Allocator_MoveableMemory SCOREP_AnyHandle
    ctypedef SCOREP_AnyHandle SCOREP_SourceFileHandle
    ctypedef SCOREP_AnyHandle SCOREP_MetricHandle
    ctypedef SCOREP_AnyHandle SCOREP_SamplingSetHandle
    ctypedef SCOREP_AnyHandle SCOREP_RegionHandle

# Region annotations
cdef extern from "scorep/SCOREP_User_Types.h":
    ctypedef struct SCOREP_User_Region:
        pass
    ctypedef SCOREP_User_Region* SCOREP_User_RegionHandle

    ctypedef uint32_t SCOREP_User_RegionType

    ctypedef uint32_t SCOREP_User_MetricType

    ctypedef uint64_t SCOREP_User_ParameterHandle

    cdef SCOREP_User_RegionHandle SCOREP_USER_INVALID_REGION
    cdef int SCOREP_USER_REGION_TYPE_COMMON
    cdef int SCOREP_USER_REGION_TYPE_FUNCTION
    cdef int SCOREP_USER_REGION_TYPE_LOOP
    cdef int SCOREP_USER_REGION_TYPE_DYNAMIC
    cdef int SCOREP_USER_REGION_TYPE_PHASE

    cdef int SCOREP_USER_METRIC_TYPE_INT64
    cdef int SCOREP_USER_METRIC_TYPE_UINT64
    cdef int SCOREP_USER_METRIC_TYPE_DOUBLE

    cdef int SCOREP_USER_METRIC_CONTEXT_GLOBAL
    cdef int SCOREP_USER_METRIC_CONTEXT_CALLPATH

# Marking start and end of regions
cdef extern from "scorep/SCOREP_User_Functions.h":

    void SCOREP_User_RegionBegin(SCOREP_User_RegionHandle *handle,
                                 char **lastFileName,
                                 SCOREP_SourceFileHandle *lastFile,
                                 char *name,
                                 SCOREP_User_RegionType regionType,
                                 char *fileName,
                                 uint32_t lineNo)

    void SCOREP_User_RegionEnd(SCOREP_User_RegionHandle handle)

    void SCOREP_User_RegionInit(SCOREP_User_RegionHandle *handle,
                                char **lastFileName,
                                SCOREP_SourceFileHandle *lastFile,
                                char *name,
                                SCOREP_User_RegionType regionType,
                                char *fileName,
                                uint32_t lineNo)

    void SCOREP_User_RegionEnter(SCOREP_User_RegionHandle handle)

    void SCOREP_User_RewindRegionEnter(SCOREP_User_RegionHandle handle)

    void SCOREP_User_EnableRecording()

    void SCOREP_User_DisableRecording()

    bool SCOREP_User_RecordingEnabled()
    
