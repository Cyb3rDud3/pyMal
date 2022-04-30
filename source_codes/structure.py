import shutil
from zipfile import ZipFile
import os

import pyminizip

from Utils.helpers import random_string
from pyminizip import compress_multiple

def get_zip_roots(base_folder):
    roots = []
    for root,dirs,files in os.walk(base_folder):
        roots.append(root)
    return roots

class ArchiveHandler:
    def __init__(self, archive_file,password,base_dir=os.getcwd()):
        self.archive = archive_file
        self.password = password
        self.base_dir = base_dir
        self.random_folder_name = random_string(is_random=True)


    def is_already_unpacked(self):
        for directory in os.listdir(self.base_dir):
            if os.path.isdir(directory):
                if directory == self.random_folder_name:
                    return True
        return False

    def unpack(self):
        with ZipFile(self.archive) as file:
            file.extractall(path=self.random_folder_name,pwd=self.password)
        return os.path.abspath(os.path.join(os.getcwd(),self.random_folder_name))

    def generate_zip_password(self):
        if os.path.exists('zip_password.py'):
            os.remove('zip_password.py')
        with open('zip_password.py','w') as new_password_file:
            random_password = random_string(is_random=True)
            declare_password = f"PASSWORD = '{random_password}'"
            new_password_file.write(declare_password)
            return random_password

    def locate_zip_password(self):
        from .zip_password import PASSWORD
        if not PASSWORD:
            return self.generate_zip_password()
        return PASSWORD

    def overwrite_previous_zip(self,zip_path):
        if os.path.exists("../sources.zip"):
            os.remove("../sources.zip")
        shutil.copyfile(zip_path,"../sources.zip")


    def pack(self,source_path: str,dst_name: str):
        if not dst_name.endswith('.zip'):
            dst_name += ".zip"
        dst_password = self.locate_zip_password()
        file_list = get_zip_roots(source_path)
        pyminizip.compress_multiple(file_list,dst_name,dst_password,9)
        self.overwrite_previous_zip(dst_name)

"""
Flow ==> 
1. python handle && pyinstaller obfuscation
2. try to unpack the sources.zip with password from .zip_password file
3. compile the unpacked content into single binary

"""