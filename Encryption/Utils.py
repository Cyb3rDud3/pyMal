from cryptography.fernet import Fernet
key = Fernet.generate_key()
encryptor = Fernet(key)


def xor(data, key):
    """XOR?
    # //TODO: add doc for this whole thing
    """
    return bytearray(a ^ b for a, b in zip(*map(bytearray, [data, key])))


def encrypt(path, folder, file):
    # //TODO: add doc for this whole thing
    try:
        # ToEncrypt = open(f'{path}/{folder}/{file}', 'rb').read()
        # token = f.encrypt(bytes(ToEncrypt))
        # Already = open(f'{path}/{folder}/{file}.ThisIsClassHomeworks', 'wb').write(token)
        # print(f'{path}/{folder}/{file}')
        # os.remove(f'{path}/{folder}/{file}')
        pass
    except Exception as e:
        pass
    return 0


