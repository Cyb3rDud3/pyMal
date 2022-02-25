import psutil
debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']


def find_debug_process() -> bool:
    """we return true if we found any debug process exists, else false"""
    for debug_proc in debug_process:
        for process in psutil.process_iter():
            if debug_proc in process.name().lower():
                return True
    return False
