from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("helpers.pyx", language_level = "3str")
)