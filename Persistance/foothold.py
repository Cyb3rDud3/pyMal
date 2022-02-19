import shutil
import subprocess
import os
import random
import base64
from Utils.helpers import is_os_64bit,run_pwsh,is_msvc_exist
import requests
from zipfile import ZipFile
from .pyinstaller_obfuscate.obfuscationModule.main import Obfuscate
from .pyinstaller_obfuscate.main import obfuscate_files
def get_pyinstaller(pythonPath,admin=True):
    URL = "https://github.com/pyinstaller/pyinstaller/archive/refs/tags/v4.7.zip"
    PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/pyinstaller-4.7.zip"
    if os.path.exists(PATH):
        os.remove(PATH)
    if os.path.exists(PATH.replace('.zip','')):
        shutil.rmtree(PATH.replace('.zip',''))
    with requests.get(URL, stream=True) as r:
        r.raise_for_status()
        with open(PATH, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                # If you have chunk encoded response uncomment if
                # and set chunk_size parameter to None.
                # if chunk:
                f.write(chunk)
    with ZipFile(PATH) as zf:
        zf.extractall(f"c:/users/{os.getlogin()}/appdata/local/temp/")
    if admin:
        if is_msvc_exist():
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/",python_path=pythonPath).obfuscate():
                pass
        else:
            gcc = "https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-9.0.0-msvcrt-r6/winlibs-x86_64-posix-seh-gcc-11.2.0-mingw-w64-9.0.0-r6.zip"
            PATH = f"c:/users/{os.getlogin()}/appdata/local/temp/gcc.zip"
            if os.path.exists(PATH):
               os.remove(PATH)
            if os.path.exists("c:/MinGW"):
                shutil.rmtree("c:/MinGW")
            with requests.get(gcc, stream=True) as r:
                r.raise_for_status()
                with open(PATH, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        # If you have chunk encoded response uncomment if
                        # and set chunk_size parameter to None.
                        # if chunk:
                        f.write(chunk)
            with ZipFile(PATH) as zf:
                zf.extractall(f"c:/MinGW")
            os.system(r'setx PATH "C:\MinGW\mingw64\bin;%PATH%"')
            if Obfuscate(base_dir=f"c:/users/{os.getlogin()}/appdata/local/temp/",python_path=pythonPath).obfuscate():
                obfuscate_files(extraction_path=f"c:/users/{os.getlogin()}/appdata/local/temp/",name="test",base_path=f"c:/users/{os.getlogin()}/appdata/local/temp/try_this",pythonPath=pythonPath)
            #get gcc?
            pass
    #get runw.
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