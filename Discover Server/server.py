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

@app.route('/cityguides/merchants', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/merchants', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/cityguides/healthcheck', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/cityguides/categories', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/categories', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/atm/healthcheck', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_ATM_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/atm/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/atm/locations', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_ATM_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/atm/v1/locations', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/tip/healthcheck', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_TIPETIQUETTE_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/tip/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/tip/guide', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_TIPETIQUETTE_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/tip/v1/guide', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/currency/healthcheck', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/currency/exchangerate', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/exchangerate', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/currency/languages', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/languages', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/offers/healthcheck', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCIOFFERS_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci-offers/v2/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/offers/offers', methods=['GET'])
def cityguides_merchants():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCIOFFERS_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci-offers/v2/offers', headers = headers)
    return(json.dumps(response_body.text), 200)




if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0", port=8080, use_reloader = False, threaded = True)




