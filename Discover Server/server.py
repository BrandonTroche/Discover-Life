from flask import Flask, render_template, request, redirect, Response, session
from pymongo import MongoClient
from math import radians, sin, cos, acos
# from urllib import request
# from urllib.request import urlopen
# from urllib.parse import urlencode, quote_plus
import requests
import json

app = Flask(__name__, template_folder="templates")
app.debug = True 
app.secret_key = "sjfavnjtlieniovnoiv90tn2u4"

client = MongoClient('mongodb://brandon:password@ds129484.mlab.com:29484/discoverlife')
db = client['discoverlife']

collection_users = db.users
collection_events = db.events

latitude = 0.0
longitude = 0.0

@app.route('/user', methods=['POST'])
def user():
    pass

@app.route('/new_user', methods=['POST', 'GET'])
def new_user():
    pass

@app.route('/location', methods=['POST'])
def location():
    pass


@app.route('/check_events', methods=['GET'])
def check_events():
   pass

@app.route('/test', methods=['GET'])
def test():
    # url = 'https://api.discover.com/cityguides/v2/cities'
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    # request = Request(url, headers=headers)
    # request.get_method = lambda: 'GET'
    # response_body = urlopen(request).read()
    response_body = requests.get('https://api.discover.com/cityguides/v2/cities', headers = headers)
    return(json.dumps(response_body.text), 200)

if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0", port=8080, use_reloader = False, threaded = True)