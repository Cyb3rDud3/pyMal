import random
import string
import subprocess


# //TODO: add doc for this whole thing


class Utils:
    def __init__(self):
        self.fileNames = {}
        self.stringDictionary = {}
        self.tcl_strings = {}
        self.tk_strings = {}
        self.new_pyz = self.random_pyz_str()
        self.new_pyl = self.random_pyz_str()
        self.new_pkg = self.random_pyz_str()
        self.new_tcl = self.random_pyz_str()
        self.magic_str = self.random_magic_str()
        self.new_mei = self.random_mei_str()
        self.base_zip = self.random_py_installer_str() + '.zip'
        self.pyinstaller_new = self.random_py_installer_str()
        self.py_installer_lower_new = self.random_py_installer_str()
        self.meipass_env = self.random_mark_string()
        pass

    def random_string(self) -> str:
        return ''.join([random.choice(string.ascii_letters) for j in range(random.randrange(6, 15))])

    def random_mark_string(self) -> str:
        return ''.join([random.choice(string.ascii_letters) for i in range(random.randrange(3, 10))] + ['_'] + [
            random.choice(string.ascii_letters) for j in range(random.randrange(10, 30))])

    def random_py_installer_str(self) -> str:
        return ''.join([random.choice(string.ascii_letters) for j in range(random.randrange(10, 30))])

    def random_mei_str(self) -> str:
        return ''.join([random.choice(string.ascii_letters) for j in range(random.randrange(3, 5))])

    def random_magic_str(self) -> str:
        return ''.join([random.choice(string.ascii_uppercase) for j in range(3)])

    def random_pyz_str(self) -> str:
        return ''.join([random.choice(string.ascii_lowercase) for j in range(3)])

    def run_process(self, cmd):
        pkwargs = {
            'close_fds': True,  # close stdin/stdout/stderr on child
            'creationflags': 0x00000008 | 0x00000200 ,
        }
        si = subprocess.STARTUPINFO()
        si.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        p = subprocess.Popen(cmd, stderr=subprocess.PIPE, stdout=subprocess.PIPE,**pkwargs)
        stdout,stderr = p.communicate()
        if stderr:
            return [stderr]
        return stdout

    @property
    def original_pyinstaller_str(self) -> str:
        return "PyInstaller"

    @property
    def original_pyinstaller_lower(self) -> str:
        return "pyinstaller"
