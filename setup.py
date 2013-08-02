from setuptools import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext

cmdclass = {'build_ext' : build_ext}

import os

from distutils.sysconfig import get_config_var
MPICC = 'mpicc -v'
MPICXX = 'mpicxx'
ld = get_config_var('LDSHARED')
cc = get_config_var('CC')

# Futz up linker command too
if ld.startswith(cc):
    ld = MPICC + ld[len(cc):]

os.environ['CC'] = MPICC
os.environ['CXX'] = MPICXX
os.environ['LDSHARED'] = ld
home = os.environ['HOME']
scorep_root = '%s/Projects/SoHPC/scorep-1.1.1' % home
ext_modules = [Extension('scorep',
                         # Dependencies
                         ['scorep.pyx', 'scorep_user.pxd',
                          'scorep_internals.pxd'],
                         # Fix these up to point to the correct places
                         # in the scorep directory tree
                         # This assumes all these files have been
                         # written to scorep-.../python/
                         include_dirs=['%s/include' % scorep_root,
                                       '%s/src/measurement/include' % scorep_root],
                         extra_compile_args=['-DSCOREP_USER_ENABLE'],
                         library_dirs=
                         ['%s/root/lib' % home],
                         runtime_library_dirs=
                         ['%s/root/lib' % home],
                         # This wants changing if doing mixed mpi/omp
                         # profiling or some such
                         libraries=['scorep_mpi'])]

setup(cmdclass=cmdclass,
      ext_modules=ext_modules)
               
