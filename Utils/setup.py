from setuptools import setup
from Cython.Build import cythonize
import Cython.Compiler.Options
Cython.Compiler.Options.docstrings = False
Cython.Compiler.Options.emit_code_comments = True

setup(
    ext_modules = cythonize("backup/helpers.pyx", language_level = "3str",)
)