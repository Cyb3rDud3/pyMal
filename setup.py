from setuptools import setup
from Cython.Build import cythonize
from shutil import copyfile
setup(
    ext_modules = cythonize("Evasion/backup/debugEvasion.pyx", language_level = "3str")

)
copyfile("build/lib.win-amd64-3.8/debugEvasion.cp38-win_amd64.pyd","Evasion/debugEvasion.cp38-win_amd64.pyd")