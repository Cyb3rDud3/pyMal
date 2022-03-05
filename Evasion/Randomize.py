import random
from base64 import b64encode, a85encode
from string import printable, ascii_letters
from random import choice, randrange
from os import urandom, system
from hashlib import sha512

GB = 1073741824


def random_base64():
    to_alloc = (GB // randrange(30, 80))
    random_factor = randrange(1, 10) >= 5
    if random_factor:
        return choice(dir(globals()))
    return b64encode(''.join([choice(printable) for _ in range(to_alloc)]).encode()).decode()


def random_a85():
    to_alloc = (GB // randrange(30, 80))
    random_factor = randrange(1, 10) >= 5
    if random_factor:
        return choice([dir(dir()), urandom(randrange(1, random_factor * 3)),
                       sha512(urandom(5)).hexdigest()])
    return a85encode(''.join([choice(printable) for _ in range(to_alloc)]).encode()).decode()


def random_list():
    to_alloc = (GB // randrange(30, 80))
    random_factor = randrange(1, 10) >= 5
    if random_factor:
        return choice([lambda: open(f'{choice(ascii_letters)}.{randrange(1, 5)}', 'wb').write(urandom(3)),
                       lambda: None,
                       lambda: system(choice(['whoami', 'cd', f'echo {randrange(1, 100)}']))])()
    return [choice(printable) for _ in range(to_alloc)]


def random_byte():
    to_alloc = (GB // randrange(30, 80))
    return urandom(to_alloc)


