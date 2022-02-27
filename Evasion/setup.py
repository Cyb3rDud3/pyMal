from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("backup/debugEvasion.pyx", language_level = "3str")
)