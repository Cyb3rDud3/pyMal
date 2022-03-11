requests.packages.urllib3.disable_warnings()
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
startupFolder = "c:/users/{}/appdata/roaming/microsoft/windows/start menu/programs/startup/{}"
tempFolder = "c:/users/{}/appdata/local/temp/{}"
BaseTempFolder = "c:/users/{}/appdata/local/temp"
TypicalRegistryKey = "SOFTWARE\Microsoft"


def setRegistryKey( key_name : str, value : str, registry_path : str, HKLM=False) -> bool:
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


def getRegistryKey(key_name : str,registry_path : str,HKLM = False) -> bool:
    """
    :param key_name: registry key name
    :type key_name: str
    :param registry_path: full path to registry key
    :type registry_path: str
    :param HKLM: is HKLM
    :type HKLM: bool
    :return: bool
    """


def extract_zip(extraction_path : str , file_to_extract : str) -> bool:
    """
    :param extraction_path: full path to the dir that we will extract the zip into
    :param file_to_extract: name of file (possibly full path) of file to extract
    """



def is_online() -> bool:
    """check if we can access google.com. """

def is_gcc_in_path() -> bool:
    """
    return bool indicating whether mingw exists.
    """

def is_python_exist() -> bool:
    """check if python exist."""



def install_with_pyinstaller(pyinstaller_path : str ,base_dir : str,file_to_install : str, onefile=True, hidden_imports=False) -> bool:
    """
    :param str pyinstaller_path: full path to pyinstaller exe
    :param str base_dir: base_dir of the file to install.
    :param str file_to_install: name of py/pyx file to install
    :param bool onefile: is onefile. default true
    :param list hidden_imports: list of hidden imports to include. can be default none

    //TODO 14: THIS IS NOT UNDERSTANDABLE FUNCTION! FIX IT
    //TODO 15: we use here run_pwsh, but we might dont want powershell. but a hidden subprocess.
    """

def is_admin() -> bool:
    """Returns true if user is admin."""


def download_file(path : str, URL : str) -> bool:
    """
    :param str path: full path on file system to download the file into
    :param str URL: url to download from.
    """

def hide_path(p : str) -> bool:
    """
    :param p: path that we want to make "hidden" using windows api.
    """


def baseRandomstr(length: str) -> str:
    """we do this here, as closures can't be applied inside cpdef"""

def random_string(length : int =0,is_random=False, is_zip=False, is_exe=False, is_py=False) -> str:
    """
    :param length: length of random string.
    """


def run_pwsh(code : str) -> str:
    """
    :param code: powershell code to run

    //TODO 16: add creation flags to make hidden, but still get stdout.
    """


def run_detached_process(code : str,is_powershell : bool =False) -> str: """"""



def is_os_64bit() -> bool:
    """
    returns True if os is 64bit, False if 32bit
    """



def find_python_path() -> str:""""""


def base64_encode_file(file_path : str) -> str:
    """
    we are gonna read the file in rb mode, encode in base64, and return the base64.
    :param file_path: full path to file to encode in base64.
    """

def base85_encode_file(file_path : str) -> str:
    """
    we are gonna read the file in rb mode, encode in base85, and return the base85.
    :param file_path: full path to file to encode in base85.
    """

def a85_encode_file(file_path : str) -> str:
    """
    we are gonna read the file in rb mode, encode in a85, and return the a85.
    :param file_path: full path to file to encode in a85.
    """


def get_current_file_path() -> str:
    """
    this function return the full current path to the exe running.
    """

def is_msvc_exist() -> bool:
        """
        this function check in the registry if we have visual studio installed.
        we return True if we find something. false if else.
        //TODO 18: find better ways to do this
        """

def ctypes_update_system() -> bool:
    """
    use ctypes to call SendMessageTimeout directly
    to send broadcast to all windows.
    """



def set_env_variable(name : str,value : str) -> bool:
    '''
    :param name: environment variable name
    :param value: environment variable value
    '''
