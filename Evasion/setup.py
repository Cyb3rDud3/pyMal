from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("backup/utils.pyx", language_level = "3str")
)