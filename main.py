from Persistance.foothold import get_pyinstaller,install_python
from Utils.helpers import is_python_exist,is_online,find_python_path,is_admin
from sys import exit as sys_exit
from os.path import join as path_join

def main():
    #//TODO: add doc
    if not is_online():
        sys_exit('NOT ONLINE')

    if not is_python_exist():
        install_python()

    pythonPath = path_join(find_python_path(),'python.exe')
    if not is_admin():
        get_pyinstaller(pythonPath,admin=False)
    else:
        get_pyinstaller(pythonPath)



if __name__ == "__main__":
    main()