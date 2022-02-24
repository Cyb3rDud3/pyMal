import psutil

debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']


def find_debug_process() -> bool:
    """we return true if we found any debug process exists, else false"""
    for debug_proc in debug_process:
        for process in psutil.process_iter():
            if debug_proc in process.name().lower():
                return True
    return False



def is_enough_cores() -> bool:
    """returns true if we have more than 4 cores (including HT!)"""
    return psutil.cpu_count() > 4

def is_enough_ram() -> bool:
    """returns true if we have more than 4GB of ram"""
    #/TODO: 35 this is probably not working as we calculated the bytes bad.
    #/recreate ASAP
    return (psutil.virtual_memory().total / 1000) > 4

def is_enough_disk() -> bool:
    """returns true if we have more than 100gb on the system drive"""
    #/TODO: SAME AS 35
    return (psutil.disk_usage("C:\\").total / 1000) > 100