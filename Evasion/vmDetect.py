from Utils.backup.helpers import run_pwsh
import psutil
# //TODO: add doc for this whole thing


def detect_vm_by_wmi() -> bool:
    #false --> not vm, true --> vm
    """Stupid but working.
    //TODO: we have lot's of things to check before running this tests.
    this test is noisy and we should avoid it as much as we can."""
    commands = {'WMIC BIOS GET SERIALNUMBER': [],
                'WMIC COMPUTERSYSTEM GET MODEL': ['HVM domU', 'Virtual Machine', 'VirtualBox', 'KVM',
                                                  'VMware Virtual Platform'],
                'WMIC COMPUTERSYSTEM GET MANUFACTURER': ['innotek GmbH', 'VMware, Inc.', 'Microsoft Corporation',
                                                         'Xen',
                                                         'Red Hat']}
    an = "Get-WmiObject Win32_PortConnector"
    q = run_pwsh(an)
    if 'tag' in q.lower():
        return True
    for k, v in commands.items():
        j = run_pwsh(k)
        for output in v:
            if output in j:
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


