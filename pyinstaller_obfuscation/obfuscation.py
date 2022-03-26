import logging
import os
import random
import re
import sys
from typing import List
from pathlib2 import Path
from pyinstaller_obfuscation.helpers import Utils

FORMAT = '%(asctime)s %(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger("obfuscatorLogger")
logger.setLevel(5)
# //TODO: add doc for this whole thing


class Obfuscate:
    """
    :param base_dir: full path for the base_dir where setup.py located. if not provided, we are gonna use os.getcwd()
    :type base_dir: str
    :param compression_level: level of compression in pyinstaller bootloader. default is 9 and you have no reason to change it probably
    :type compression_level: int
    :param python_path: full path for python.exe. default is sys.executable
    :type python_path: str
    """
    def __init__(self, base_dir=os.getcwd(), compression_level=9,python_path=sys.executable):
        self.base_dir = base_dir
        self.compression_level = compression_level
        self.pyinstaller_dir = os.path.join(self.base_dir, "PyInstaller")
        self.archive_dir = os.path.join(self.pyinstaller_dir, 'archive')
        self.loader_dir = os.path.join(self.pyinstaller_dir, 'loader')
        self.bootloader_dir = os.path.join(self.base_dir, 'bootloader')
        self.bootloader_src_dir = os.path.join(self.bootloader_dir, 'src')
        self.py_writers_file = os.path.join(self.archive_dir, 'writers.py')
        self.py_readers_file = os.path.join(self.archive_dir, 'readers.py')
        self.loader_archive_file = os.path.join(self.loader_dir, 'pyimod02_archive.py')
        self.pyi_utils = os.path.join(self.bootloader_src_dir, 'pyi_utils.c')
        self.wscript_file = os.path.join(self.bootloader_dir, 'wscript')
        self.python_path = python_path
        self.utils = Utils()
        self.error_strings = {"LOADER:",
                              "SPLASH:",
                              "Cannot allocate memory",
                              "Cannot find requirement",
                              "Tcl is not threaded. Only threaded tcl is supported.",
                              "Cannot extract requirement",
                              "Could not allocate buffer for",
                              "Error loading Python DLL",
                              "Error creating child process!",
                              "Module object for",
                              "Could not read full TOC!",
                              "Error on file.",
                              "Path of DLL",
                              "length exceeds",
                              "Absolute path to script exceeds",
                              "No error messages generated.",
                              "Path of ucrtbase.dll",
                              "Reported length",
                              "to extract",
                              "Failed",
                              "to allocate",
                              "to convert",
                              "to set",
                              "to get address for",
                              "to read data chunk!",
                              "executable path to",
                              "progname to",
                              "to get _MEIPASS as",
                              "to unmarshal code object for",
                              "to load tcl/tk libraries",
                              "to seek to cookie position!",
                              "to append to"}
        self.__tcl_fingerprints = {"tcl_findLibrary",
                             "tclInit",
                             "exit",
                             "rename ::source ::_source",
                             "source",
                             "tcl_patchLevel",
                             "tk_patchLevel",
                             "_image_data",
                            "status_text",
                                   "tk.tcl",
                                   "tk_library",
                                   "_source"}
        self.__fingerprints = {#"calloc",
                               #"win32_wcs_to_mbs",
                               #"malloc",
                               "WideCharToMultiByte",
                               "win32_utils_to_utf8",
                               "win32_utils_from_utf8",
                               "GetModuleFileNameW",
                              # "pkg",
                              # "fread",
                              # "fwrite",
                             #  "fseek",
                              # "fopen",
                              # "ucrtbase.dll",
                              # "LoadLibrary",
                               }
        self.__fingerprints_placements = {
            'pyi_utils.c' : 'static int argc_pyi = 0;',
            'pyi_win32_utils.c' : r'.*GetWinErrorString\(.*',
            'pyi_splash.c' : 'static Tcl_Condition exit_wait;',
            'pyi_pythonlib.c' : r'int\s+pyi_pylib_load.*',
            'pyi_path.c' : r'bool\s+pyi_path_dirname.*',
            'pyi_main.c' : r'int\s+pyi_main.*',
            'pyi_launch.c' : '#define _MAX_ARCHIVE_POOL_LEN 20',
            'pyi_global.c' : 'char *saved_locale;',
            'pyi_exception_dialog.c' : '#pragma pack(push, 4)',
            'pyi_archive.c' : 'int pyvers = 0;'

        }
        self.function_filenames = {'pyi_pythonlib.c','pyi_path.c','pyi_main.c','pyi_win32_utils.c'}

        self.obfuscated_files = set()


    def tamper_magic(self):
        """this method is gonna open 2 files, and modify the MAGIC HEADER of pyinstaller
        by doing that, we avoid first-line decompilers of pyinstaller.
        we should note that this is still MORE THAN POSSIBLE do figure out the magic numbers and decompile."""
        magic_numbers = [random.randrange(1, 7) for i in range(5)]
        writers_py_file, readers_py_file = Path(self.py_writers_file), Path(self.py_readers_file)
        writers_text, readers_text = writers_py_file.read_text(), readers_py_file.read_text()
        writers_text = re.sub(r"MEI.*\b",
                              rf"""{self.utils.magic_str}\\01{magic_numbers[0]}\\01{magic_numbers[1]}\\01{magic_numbers[2]}\\01{magic_numbers[3]}\\01{magic_numbers[4]}""",
                              writers_text)
        writers_text = self.replace_compression_level(writers_text)
        writers_py_file.write_text(writers_text)
        readers_text = re.sub(r"MEI.*\b",
                              rf"""{self.utils.magic_str}\\01{magic_numbers[0]}\\01{magic_numbers[1]}\\01{magic_numbers[2]}\\01{magic_numbers[3]}\\01{magic_numbers[4]}""",
                              readers_text)
        readers_py_file.write_text(readers_text)
        pyi_archive_c_file = Path(os.path.join(self.bootloader_src_dir, 'pyi_archive.c'))
        pyi_archive_c_text = pyi_archive_c_file.read_text()
        pyi_archive_c_text = pyi_archive_c_text.replace("'M', 'E', 'I', 014,",
                                                        f"'{self.utils.magic_str[0]}', '{self.utils.magic_str[1]}', '{self.utils.magic_str[2]}', 01{magic_numbers[0]},")
        pyi_archive_c_text = pyi_archive_c_text.replace("013, 012, 013, 016",
                                                        f"01{magic_numbers[1]}, 01{magic_numbers[2]}, 01{magic_numbers[3]}, 01{magic_numbers[4]}")
        pyi_archive_c_file.write_text(pyi_archive_c_text)
        return

    def edit_linker(self):
        wscript_bootloader = Path(self.wscript_file)
        wscript_bootloader_text = wscript_bootloader.read_text()
        wscript_bootloader_text = wscript_bootloader_text.replace("# Disable warnings about unsafe CRT functions",
                                                                  "ctx.env.append_value('LINKFLAGS', '/BASE:0x00400000')")
        wscript_bootloader_text = wscript_bootloader_text.replace(
            "# We use SEH exceptions in winmain.c; make sure they are activated.",
            "ctx.env.append_value('LINKFLAGS', '/DYNAMICBASE:NO')")
        wscript_bootloader_text = wscript_bootloader_text.replace("# Set the PE checksum on resulting binary",
                                                                  "ctx.env.append_value('LINKFLAGS', '/VERSION:5.2')")
        wscript_bootloader.write_text(wscript_bootloader_text)
        return

    def find_pyi_strings(self, current_file_text) -> List:
        """
        :param current_file_text: Path().read_text() of current file iter
        """
        return re.findall(r"^pyi_.[^\(]+", current_file_text, flags=re.MULTILINE | re.DOTALL)

    def find_tcl_strings(self, current_file_text):
        """
        :param current_file_text: Path().read_text() of current file iter
         """
        return re.findall(r"tcl_", current_file_text, flags=re.IGNORECASE)

    def find_tk_strings(self, current_file_text):
        """
         :param current_file_text: Path().read_text() of current file iter
        """
        return re.findall(r"tk_", current_file_text, flags=re.IGNORECASE)

    def replace_compression_level(self, file_obj: str):
        file_obj = file_obj.replace("COMPRESSION_LEVEL = 6", f"COMPRESSION_LEVEL = {self.compression_level}")
        file_obj = file_obj.replace("# First compress then encrypt.",
                                    """obj = obj.translate(bytes.maketrans(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                        b"nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"))[::-1]""")
        file_obj = file_obj.replace("self.lib.write(f.read())", "self.lib.write(f.read()[::-1])")
        return file_obj

    def tamper_archive_loader(self):
        py_archive_loader = Path(self.loader_archive_file)
        py_archive_text = py_archive_loader.read_text()
        py_archive_text = py_archive_text.replace("obj = zlib.decompress(obj)", """obj = zlib.decompress(obj.translate(bytes.maketrans(b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                 b"nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"))[::-1])""")
        py_archive_text = py_archive_text.replace("obj = marshal.loads(self.lib.read())",
                                                  "obj = marshal.loads(self.lib.read()[::-1])")
        py_archive_loader.write_text(py_archive_text)
        return

    def introduce_random_mei(self):
        utils_file = Path(self.pyi_utils)
        utils_text = utils_file.read_text()
        utils_text = utils_text.replace("#include <signal.h>",
                                        "#include <signal.h>\n#include <time.h>\n#include <stdlib.h>\n")
        utils_text = utils_text.replace('swprintf(prefix, 16, L"_MEI%d", getpid());',
                                        f'srand(time(NULL));\nswprintf(prefix, 16, L"_{self.utils.new_mei}%d", rand() % getpid());')
        utils_text = utils_text.replace('strcat(buff, "_MEIXXXXXX");', f'strcat(buff, "_{self.utils.new_mei}XXXXXX");')
        utils_file.write_text(utils_text)
        return

    def remove_c_comments(self):
        return

    def change_baselib_name(self):
        return

    def obfuscate_c_errors(self):
        return


    def replace_pyz(self):
        return

    def replace_pyl(self):
        return

    def replace_pkg(self):
        return


    def obfuscate_splashlib(self,current_file_text,filename):
        if 'splash' not in filename:
            return current_file_text
        for fingerprint in self.__tcl_fingerprints:
            stack_string = "{" + ','.join(["'%s'" % i for i in fingerprint]) + "}"
            fingerprinted = re.findall(rf'"{fingerprint}.*?(?<!\\)"', current_file_text)
            char_name = self.utils.random_string()
            lines = current_file_text.splitlines()
            for line in lines:
                if "static Tcl_Mutex status_mutex" in line:
                    current_file_text = re.sub(line, f"{line}\nchar {char_name}[] = {stack_string};", current_file_text)
                    break
            for fingerprint_str in fingerprinted:
                current_file_text = re.sub(fingerprint_str, char_name, current_file_text)
        return current_file_text

    def obfuscate_fingerprint(self, current_file_text,filename):
        placement = self.__fingerprints_placements[filename]
        for fingerprint in self.__fingerprints:
            stack_string = "{" + ','.join(["'%s'" % i for i in fingerprint]) + "}"
            fingerprinted = re.findall(rf'"{fingerprint}.*?(?<!\\)"', current_file_text)
            if not fingerprinted:
                continue
            char_name = self.utils.random_string()
            lines = current_file_text.splitlines()
            print(filename)
            if filename in self.function_filenames:
                print(placement)
                find_func = re.findall(placement,current_file_text)
                if find_func:
                    before = find_func[0]
                    regex = re.compile(placement)
                    current_file_text = re.sub(regex, f"char {char_name}[] = {stack_string};\n{before}\n", current_file_text)
            else:
                for line in lines:
                    if placement in line or placement == line:
                        current_file_text = re.sub(line, f"char {char_name}[] = {stack_string};\n{line}\n", current_file_text)
                        break
            for fingerprint_str in fingerprinted:
                current_file_text = re.sub(fingerprint_str, char_name, current_file_text)
        self.obfuscated_files.add(filename)
        return current_file_text

    def replace_pyinstaller_upper(self):
        return

    def replace_pyinstaller_lower(self):
        return

    def recompile_bootloader(self):
        # TODO: find python path
        os.chdir(self.bootloader_dir)
        print(os.getcwd(),self.python_path)
        self.utils.run_process(rf"{self.python_path} -m pip install wheel")
        tryCompile = self.utils.run_process(rf"{self.python_path} waf distclean all")
        logger.info(tryCompile)
        if type(tryCompile) == list or len(tryCompile) < 2:
            logger.error(f"ERROR COMPILING BOOTLOADER {tryCompile} ")
            return False
        logger.info("DONE COMPILING BOOTLOADER")
        return True

    def reinstall_pyinstaller(self):
        if not self.recompile_bootloader():
            logger.error("you got error in compiling the bootloader. exiting")
            return False
        os.chdir(self.base_dir)
        tryUninstallExisting = self.utils.run_process(f"{self.python_path} -m pip uninstall pyinstaller --yes")
        tryInstall = self.utils.run_process(f"{self.python_path} setup.py install")
        if type(tryInstall) == list and b'warning' not in tryInstall[0]:
            logger.error("ERROR INSTALLING PYINSTALLER")
            logger.error(tryInstall)
            sys.exit()
        logger.info("DONE INSTALLING PYINSTALLER.")
        return True

    def gather_important_strings(self):
        """we go over all the files of the bootloader/src, and we collect information about strings to replace.
        we store every matching string in this Utils instance inside a dictionary, for later user to replace.
        we are currently only iterating over pyi_.* strings, as other's seems buggy. so we have lot's of TODO over here"""
        os.chdir(self.base_dir)  # make sure tht base_dir is pyinstaller-version file
        for file in os.listdir(self.bootloader_src_dir):
            if file not in self.utils.fileNames:
                self.utils.fileNames[file] = self.utils.random_string() + '.' + file.split('.')[1]
            current_file = Path(os.path.join(self.bootloader_src_dir, file))
            current_text = current_file.read_text()
            all_pyi_strings: List = self.find_pyi_strings(current_text)
            # all_tcl_strings : List = self.find_tcl_strings(current_text) //TODO: WHY THIS IS BUGGY
            # all_tk_strings : List = self.find_tk_strings(current_text) //TODO: WHY THIS IS BUGGY
            # current_text = re.sub(r'/\*(?s:(?!\*/).)*\*/|//.*', '', current_text) //TODO: check if buggy
            # current_text = re.sub(r"FATALERROR.*\s+\b\b.*;", '', current_text) //TODO: WHY THIS IS BUGGY
            if all_pyi_strings:
                for pyi_string in all_pyi_strings:
                    if pyi_string not in self.utils.stringDictionary:
                        self.utils.stringDictionary[pyi_string] = self.utils.random_mark_string()
        return

    def replace_important_strings(self):
        """we are gonna iterate again over bootloader/src, but now we are gonna replace the strings we stored in the
        dictionary in the gather_important_strings."""
        os.chdir(self.base_dir)  # just to make sure
        for file in os.listdir(self.bootloader_src_dir):
            if file.endswith('.c') or file.endswith('.h'):
                try:
                    current_file = Path(os.path.join(self.bootloader_src_dir, file))
                    current_text = current_file.read_text()
                    current_text = self.obfuscate_splashlib(current_text, file)
                    current_file.write_text(current_text)
                    current_text = self.obfuscate_fingerprint(current_text, file)
                    current_file.write_text(current_text)
                except Exception as e:
                    logger.info(e)
                os.rename(os.path.join(self.bootloader_src_dir, file),
                          os.path.join(self.bootloader_src_dir, self.utils.fileNames[file]))
                current_file = Path(os.path.join(self.bootloader_src_dir, self.utils.fileNames[file]))
                current_text = current_file.read_text()
                for originalFilename, newFilename in self.utils.fileNames.items():
                    """fileNames is {original_file_name : obfuscated_file_name}, and we do this loop to
                       replace the original file_names in the files text with the obfuscated ones
                       this is crucial step, as we dont want a file to include other file, but the other file's name
                       has been changed."""
                    current_text = current_text.replace(originalFilename, newFilename)
                for prev_str, new_str in self.utils.stringDictionary.items():
                    current_text = current_text.replace(prev_str, new_str)
                for prev, new in self.utils.tcl_strings.items():
                    current_text = current_text.replace(prev, new)
                for prev, new in self.utils.tk_strings.items():
                    current_text = current_text.replace(prev, new)
                for error_string in self.error_strings:
                    current_text = current_text.replace(error_string, self.utils.random_string())
                current_text = current_text.replace(self.utils.original_pyinstaller_str, self.utils.pyinstaller_new)
                current_text = current_text.replace(self.utils.original_pyinstaller_lower,
                                                    self.utils.py_installer_lower_new)
                current_file.write_text(current_text)
        return

    def parse_everything(self):
        """lets parse everyting, and finish this shit"""
        os.chdir(self.base_dir)  # just to make sure
        for root, dirs, files in os.walk(os.getcwd()):
            for file in files:
                if file:
                    try:
                        current_file = Path(os.path.join(root, file))
                        current_text = current_file.read_text()
                        for originalFilename, newFilename in self.utils.fileNames.items():
                            current_text = current_text.replace(originalFilename, newFilename)
                        for prev_str, new_str in self.utils.stringDictionary.items():
                            current_text = current_text.replace(prev_str, new_str)

                        current_text = re.sub(r"^PyInstaller\b$", self.utils.pyinstaller_new,
                                              current_text)  # don't replace dirs!
                        current_text = re.sub(r"^pyinstaller\b$", self.utils.py_installer_lower_new, current_text)
                        current_text = re.sub(r"^_MEIPASS2\b$", self.utils.new_mei, current_text)
                        current_text = re.sub(r"PYZ\\0", rf"{self.utils.new_pyz.upper()}\\0", current_text)
                        current_text = re.sub(r"\.pyz\b", f".{self.utils.new_pyz.lower()}", current_text)
                        current_text = re.sub(r"PYL\\0", rf"{self.utils.new_pyl.upper()}\\0", current_text)
                        current_text = re.sub(r"\.pkg\b", f".{self.utils.new_pkg.lower()}", current_text)
                        current_text = re.sub(r"MEIPASS2", self.utils.meipass_env.upper(), current_text)
                        current_text = re.sub(r"invalid literal.*\b", self.utils.random_py_installer_str(),
                                              current_text)  # an err
                        current_text = re.sub(r"invalid distance.*\b", self.utils.random_py_installer_str(),
                                              current_text)  # an err
                        current_text = re.sub(r"lib-dynload", self.utils.random_py_installer_str(),
                                              current_text)  # relevant to unix only
                        current_text = re.sub(r"base_library.zip", self.utils.base_zip,
                                              current_text)  # change base_lib name
                        current_text = re.sub(r'"MultiByteToWideChar"', f'"{self.utils.random_py_installer_str()}"',
                                              current_text)  # another err msg
                        current_text = re.sub(r"^/*/.*/*$", '', current_text)  # remove c comments
                        current_file.write_text(current_text)
                    except Exception as e:
                        logger.info(e)
        logger.info("We Done Obfuscating, lets try to compile to boot loader")
        os.chdir(self.bootloader_dir)
        if self.reinstall_pyinstaller():
            return True
        return False


    def reset(self):
        self.pyinstaller_dir = os.path.join(self.base_dir, "PyInstaller")
        self.archive_dir = os.path.join(self.pyinstaller_dir, 'archive')
        self.loader_dir = os.path.join(self.pyinstaller_dir, 'loader')
        self.bootloader_dir = os.path.join(self.base_dir, 'bootloader')
        self.bootloader_src_dir = os.path.join(self.bootloader_dir, 'src')
        self.py_writers_file = os.path.join(self.archive_dir, 'writers.py')
        self.py_readers_file = os.path.join(self.archive_dir, 'readers.py')
        self.loader_archive_file = os.path.join(self.loader_dir, 'pyimod02_archive.py')
        self.pyi_utils = os.path.join(self.bootloader_src_dir, 'pyi_utils.c')
        self.wscript_file = os.path.join(self.bootloader_dir, 'wscript')

    def obfuscate(self):
        "//TODO: Find a way to validate base_dir && replace the base_Dir"
        for directory in os.listdir(self.base_dir):
                if 'pyinstaller-' in directory.lower() and not directory.endswith('.zip'):
                    if 'setup.py' in os.listdir(os.path.join(self.base_dir,directory)):
                        self.base_dir = os.path.join(self.base_dir, directory)
                    os.chdir(self.base_dir)
                self.reset()
        if 'pyinstaller-' not in os.getcwd():
                sys.exit(f'[*] COULD NOT FIND pyinstaller dir in {[i.lower() for i in os.listdir(self.base_dir)]} {self.base_dir}')
        self.gather_important_strings()
        self.tamper_magic()
        self.tamper_archive_loader()
        self.edit_linker()
        self.introduce_random_mei()
        self.replace_important_strings()
        if self.parse_everything():
            return True
        return False
