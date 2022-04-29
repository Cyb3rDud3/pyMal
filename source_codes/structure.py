from zipfile import ZipFile
import os
from Utils.helpers import random_string
from obfuscation.main import Obfuscator,ValidateGlobalVars,parse,unparse
def zip_dir(base_dir: str,zip_name: str,zip_password: str) -> str:
    zf = ZipFile(zip_name,"a")
    for dirname, subdirs, files in os.walk(base_dir):
        zf.write(dirname)
        for filename in files:
            zf.write(os.path.join(dirname, filename))
    zf.setpassword(zip_password.encode())
    return os.path.abspath(os.path.join(os.getcwd(),zip_name))


class ArchiveHandler:
    def __init__(self, archive_file,password,base_dir=os.getcwd()):
        self.archive = archive_file
        self.password = password
        self.base_dir = base_dir
        self.random_folder_name = random_string(is_random=True)
        self.obfuscation_tree: dict = {}
        self.obfuscator = Obfuscator()


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

    def pack(self,source_path,dst_name,dst_password):
        return zip_dir(base_dir=source_path,zip_name=dst_name,zip_password=dst_password)


    def add_file_to_tree(self,file_name,code):
        self.obfuscation_tree[file_name] = code

    def update_filename_in_tree(self,prev_filename,new_filename):
        if self.get_file_from_tree(prev_filename):
            self.obfuscation_tree[new_filename] = self.obfuscation_tree[prev_filename]
            del self.obfuscation_tree[prev_filename]

    def get_file_from_tree(self,file_name):
        return self.obfuscation_tree.get(file_name)


    def obfuscate_filenames(self,base_path):
        for root,dirs,files in os.walk(base_path):
            for __dir in dirs:
                for file in os.listdir(os.path.join(root,__dir)):
                    full_path = os.path.join(file,os.path.join(root,__dir))
                    if self.obfuscation_tree.get(full_path):
                        self.update_filename_in_tree(prev_filename=random_string(is_random=True,is_py=True))
        for file in os.listdir(base_path):
            full_path = os.path.join(base_path,file)
            if self.obfuscation_tree.get(full_path):
                self.update_filename_in_tree(prev_filename=random_string(is_random=True, is_py=True))


    def parse_module_first_time(self,module_path):
        for root, dirs, files in os.walk(module_path):
            for __dir in dirs:
                for file in os.listdir(os.path.join(root, __dir)):
                    full_path = os.path.join(file, os.path.join(root, __dir))
                    if os.path.isfile(full_path) and full_path.endswith('.py'):
                        with open(full_path, 'r') as py_file:
                            self.add_file_to_tree(file_name=full_path, code=py_file.read())
        for file in os.listdir(module_path):
            if os.path.isdir(file) and file.endswith('.py'):
                with open(os.path.join(module_path, file), 'r') as py_file:
                    self.add_file_to_tree(file_name=os.path.join(module_path, file), code=py_file.read())

    def obfuscate(self):
        for full_filename,full_code in self.obfuscation_tree.items():
            tree = parse(full_code)
            root = self.obfuscator.visit(tree)
            root = ValidateGlobalVars(self.obfuscator.global_variables,self.obfuscator.imports).visit(root)
            self.obfuscation_tree[full_filename] = unparse(root)

    def unpack_and_obfuscate(self):
        if self.is_already_unpacked():
            return os.path.join(self.base_dir,self.random_folder_name)
        unpacked_path = self.unpack()
        self.parse_module_first_time(unpacked_path)
        self.obfuscate_filenames(unpacked_path)


