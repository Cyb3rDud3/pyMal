import ctypes
from ctypes import wintypes
from ctypes import create_string_buffer, wstring_at
from ctypes import Structure, Union, POINTER
from ctypes import byref, pointer, cast
import os
import platform
import random
import shutil
import string
import subprocess
import sys
import requests
import ast
import winreg
from base64 import b64encode
from zipfile import ZipFile
requests.packages.urllib3.disable_warnings()
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW



def extract_zip(extraction_path : str,file_to_extract : str) -> bool:
    """
    :param extraction_path: full path to the dir that we will extract the zip into
    :param file_to_extract: name of file (possibly full path) of file to extract
    """
    try:
        with ZipFile(file_to_extract) as zf:
            zf.extractall(extraction_path)
        return True
    except Exception as e:
        print(e)
        return False

def top_level_functions(body):
    #//TODO 11: add doc
    return (f for f in body if isinstance(f, ast.FunctionDef))


def parse_ast(code):
    #//TODO 12: add doc
    return ast.parse(code)


def is_online() -> bool:
    """check if we can access google.com. """
    try:
        x = requests.get('https://google.com', verify=False)
        return True
    except Exception as e:
        return False


def is_python_exist() -> bool:
    """check if python exist."""
    possible_location = ['c:/Program Files','c:/Program Files (x86)','c:/ProgramData']
    python_reg_key = r"SOFTWARE\Python\PythonCore\3.{}\InstallPath"
    python_reg_value = "ExecutablePath"
    for python_minor_version in range(5, 10):
        try:
            reg_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, python_reg_key.format(python_minor_version), 0,
                                     winreg.KEY_READ)
            value, regtype = winreg.QueryValueEx(reg_key, python_reg_value)
            return True
        except WindowsError:
            continue
    for num in range(10, 45):
        if os.path.exists(f"C:/Users/{os.getlogin()}/Appdata/Local/Programs/Python/Python{num}/python.exe"):
            return True
    for location in possible_location:
        for file in os.listdir(location):
            if os.path.isdir(file) and 'python' in file.lower():
                return True
    return False


def install_with_pyinstaller(pyinstaller_path :str,base_dir : str,file_to_install: str,onefile=True,hidden_imports=None) -> bool:
    """
    :param str pyinstaller_path: full path to pyinstaller exe
    :param str base_dir: base_dir of the file to install.
    :param str file_to_install: name of py/pyx file to install
    :param bool onefile: is onefile. default true
    :param list hidden_imports: list of hidden imports to include. can be default none

    //TODO 14: THIS IS NOT UNDERSTANDABLE FUNCTION! FIX IT
    //TODO 15: we use here run_pwsh, but we might dont want powershell. but a hidden subprocess.
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
    """
    :param str path: full path on file system to download the file into
    :param str URL: url to download from.
    """
    with requests.get(URL, stream=True) as r:
        r.raise_for_status()
        with open(path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                # If you have chunk encoded response uncomment if
                # and set chunk_size parameter to None.
                # if chunk:
                f.write(chunk)
    return True

def hide_path(p : str):
    """
    :param p: path that we want to make "hidden" using windows api.
    """
    return ctypes.windll.kernel32.SetFileAttributesW(p, 0x02)


def random_string(length : int):
    """
    :param length: length of random string.
    """
    return ''.join((random.choice(string.ascii_letters) for x in range(length)))


def run_pwsh(code : str):
    """
    :param code: powershell code to run

    //TODO 16: add creation flags to make hidden, but still get stdout.
    """
    p = subprocess.run(['powershell', code], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return p.stdout.decode()


def is_os_64bit() -> bool:
    """
    returns True if os is 64bit, False if 32bit
    """
    return platform.machine().endswith('64')


def find_python_path() -> str:
    python_reg_key = r"SOFTWARE\Python\PythonCore\3.{}\InstallPath"
    python_reg_value = "ExecutablePath"
    for python_minor_version in range(5,10):
        try:
            reg_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, python_reg_key.format(python_minor_version), 0,
                    winreg.KEY_READ)
            value, regtype = winreg.QueryValueEx(reg_key, python_reg_value)
            return value
        except WindowsError:
            continue
    return None


def base64_encode_file(file_path : str) -> str:
    """
    we are gonna read the file in rb mode, encode in base64, and return the base64.
    :param file_path: full path to file to encode in base64.
    """
    with open(file_path,'rb') as file:
        base64_info = b64encode(file.read())
        return base64_info.decode()

def get_current_file_path() -> str:
    """
    this function return the full current path to the exe running.s
    """
    if getattr(sys, 'frozen', False):
        # If the application is run as a bundle, the PyInstaller bootloader
        # extends the sys module by a flag frozen=True and sets the app
        # path into variable _MEIPASS'.
        application_path = sys.executable
    else:
        application_path = os.path.dirname(os.path.abspath(__file__))
    return application_path

def is_msvc_exist() -> bool:
        """
        this function check in the registry if we have visual studio installed.
        we return True if we find something. false if else.
        //TODO 18: find better ways to do this
        """
        try:
            winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE,"SOFTWARE\Wow6432Node\Microsoft\VisualStudio",0)
            return True
        except Exception as e:
            return False


def ctypes_update_system():
    """
    use ctypes to call SendMessageTimeout directly
    to send broadcast to all windows.
    """
    SendMessageTimeout = ctypes.windll.user32.SendMessageTimeoutW
    UINT = wintypes.UINT
    SendMessageTimeout.argtypes = wintypes.HWND, UINT, wintypes.WPARAM, ctypes.c_wchar_p, UINT, UINT, UINT
    SendMessageTimeout.restype = wintypes.LPARAM
    HWND_BROADCAST = 0xFFFF
    WM_SETTINGCHANGE = 0x1A
    SMTO_NORMAL = 0x000
    SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, 'Environment', SMTO_NORMAL, 10, 0)
    return