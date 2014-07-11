#!/usr/bin/env python

"""
setup.py for pyvrui
"""

from distutils.core import setup, Extension
import subprocess

def pkg_config(*args):
   return subprocess.check_output(('pkg-config',)+args).decode('utf-8').split()

def unflag(args):
   return [x[2:] for x in args]

pyvrui_module = Extension(
   '_pyvrui',
   ['pyvrui.i'],
   swig_opts = ['-c++'] + pkg_config('--cflags-only-I', 'Vrui'),
   include_dirs = ['./src'] + unflag(pkg_config('--cflags-only-I', 'Vrui')),
   extra_compile_args = pkg_config('--cflags-only-other', 'Vrui'),
   library_dirs = unflag(pkg_config('--libs-only-L', 'Vrui')),
   libraries = unflag(pkg_config('--libs-only-l', 'Vrui')),
   extra_link_args = pkg_config('--libs-only-other', 'Vrui')
   )

setup(
   name = 'pyvrui',
   version = '0.1.0',
   author = 'Jordan Van Aalsburg',
   author_email = 'iviz@lists.cse.ucdavis.edu',
   url = 'https://github.com/comscictr/pyvrui',
   description = 'Python wraper for Vrui',
   ext_modules = [pyvrui_module],
   py_modules = ['pyvrui']
   )
