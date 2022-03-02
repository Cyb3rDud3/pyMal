import flask
from flask import Flask,request
from requests import get
from hashlib import sha512

#//TODO: flask webserver that peform Eval ON PYTHON SCRIPTS!
#//TODO: how can we make sure the server is accessible? we need to forward ports!
#//TODO: check if this is phone 4g somehow, as then this is 100% forwarded

app = Flask(__name__)
