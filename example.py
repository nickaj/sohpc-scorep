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


# Simple example demonstrating scorep usage from python
import scorep
from mpi4py import MPI
c = MPI.COMM_WORLD

def decorator(function):
  def wrapper():
    a= function.__name__
    scorep.region_begin(a)
    function()
    scorep.region_end(a)
  return wrapper
  

@decorator
def inner():

   tmp = 1
   c.Barrier()    
   for i in xrange(100):
      tmp *= (i+1)

@decorator
def outer():
  
   c.Barrier()    
   for i in xrange(100):
      inner()

outer()
