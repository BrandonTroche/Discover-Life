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

client = MongoClient('mongodb://brandon:password1@ds129484.mlab.com:29484/discoverlife')
db = client['discoverlife']

collection_users = db.users
collection_events = db.events

latitude = 0.0
longitude = 0.0

@app.route('/user', methods=['POST'])
def user():
    data_json = json.loads(request.data)
    username = data_json['username']

    if(collection_users.find_one({"username" : data_json["username"], "password": data_json["password"]})):
        user_object = collection_users.find_one({"username" : data_json["username"], "password": data_json["password"]})

        return_model = '{"username":"'+user_object['username']+'", "password": "'+user_object['password']+'"}'

        print(return_model)

        return(return_model, 200)
    else:
        print("not found")
        return('{"status_code":400}', 400)

@app.route('/new_user', methods=['POST'])
def new_user():
    data = json.loads(request.data)

    if(collection_users.find_one({"username": data['username']})):
        print("found")
        return('{"status_code":400}', 400)
    else:
        print("not found")
        collection_users.insert_one(data)
        return('{"status_code":200}', 200)

    return('{"status_code":400}', 400)

@app.route('/location', methods=['POST'])
def location():

    data = json.loads(request.data)

    print(data)

    # ret = {'res': []}

    ret = {}

    if(collection_events.find_one({"city":data["city"]})):
        all_in_city = collection_events.find({"city":data["city"]})
        for event in all_in_city:
            event["_id"] = "none"
            ret[event["event_id"]] = str(event)
            # ret['res'].append(str(event))
            # ret.append(str(event))
        return(json.dumps(ret))
    return('{"status_code":400}', 400)

@app.route('/new_event', methods=['POST'])
def check_events():
    data = json.loads(request.data)
    print("not found")
    collection_events.insert_one(data)
    return('{"status_code":200}', 200)

@app.route('/cityguides/merchants', methods=['GET'])
def cityguides_merchants():
    # auth_head = 

    # client id l7xxada69f7b2a0745b2b56715b7f1beb0c1
    # client secret 668bcc7f91a24d80b68d3e40e392962c
    # CITYGUIDES DCIOFFERS DCIOFFERS_POST DCILOUNGES DCILOUNGES_POST DCILOUNGES_PROVIDER_LG DCILOUNGES_PROVIDER_DCIPL DCI_ATM DCI_CURRENCYCONVERSION DCI_CUSTOMERSERVICE DCI_TIP DCIOFFERS_HEALTHCHECK
    # https://apis.discover.com/auth/oauth/v2/token
    # 310


    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/merchants', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/cityguides/healthcheck', methods=['GET'])
def cityguides_healthcheck():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/cityguides/categories', methods=['GET'])
def cityguides_categories():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'CITYGUIDES_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/cityguides/v2/categories', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/atm/healthcheck', methods=['GET'])
def atm_healthcheck():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_ATM_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/atm/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/atm/locations', methods=['GET'])
def atm_locations():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_ATM_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/atm/v1/locations', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/tip/healthcheck', methods=['GET'])
def tip_healthcheck():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_TIPETIQUETTE_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/tip/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/tip/guide', methods=['GET'])
def tip_guide():
    # client id l7xxada69f7b2a0745b2b56715b7f1beb0c1
    # client secret 668bcc7f91a24d80b68d3e40e392962c
    # CITYGUIDES DCIOFFERS DCIOFFERS_POST DCILOUNGES DCILOUNGES_POST DCILOUNGES_PROVIDER_LG DCILOUNGES_PROVIDER_DCIPL DCI_ATM DCI_CURRENCYCONVERSION DCI_CUSTOMERSERVICE DCI_TIP DCIOFFERS_HEALTHCHECK
    # https://apis.discover.com/auth/oauth/v2/token
    # 310

    headers = {
        'Authorization' : 'Basic bDd4eGFkYTY5ZjdiMmEwNzQ1YjJiNTY3MTViN2YxYmViMGMxOjY2OGJjYzdmOTFhMjRkODBiNjhkM2U0MGUzOTI5NjJj',
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Cache-Control': 'no-cache'
    }

    payload = "grant_type=client_credentials&scope=DCI_TIP"

    res = requests.post("https://apis.discover.com/auth/oauth/v2/token", data = payload, headers = headers)

    red_data = json.loads(res.text)

    token = red_data["access_token"]

    headers2 = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_TIPETIQUETTE_SANDBOX',  'Authorization':'Bearer '+token, 'countryisonum':'310'  }
    # pay = "?countryisonum=310"
    response_body = requests.get('https://api.discover.com/dci/tip/v1/guide?countryisonum=310', headers = headers2)
    # print(json.loads(response_body.text))
    dat = json.loads(response_body.text)
    return('{"percentage":"' + dat[2]["tipDescription"] + '"}', 200)

@app.route('/currency/healthcheck', methods=['GET'])
def currency_healthcheck():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/currency/exchangerate', methods=['GET'])
def currency_exchangerate():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/exchangerate', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/currency/languages', methods=['GET'])
def currency_languages():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCI_CURRENCYCONVERSION_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci/currencyconversion/v1/languages', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/offers/healthcheck', methods=['GET'])
def offers_healthcheck():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCIOFFERS_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci-offers/v2/healthcheck', headers = headers)
    return(json.dumps(response_body.text), 200)

@app.route('/offers/offers', methods=['GET'])
def offers_offers():
    headers = {  'Accept':'application/json',  'x-dfs-api-plan':'DCIOFFERS_SANDBOX',  'Authorization':'Bearer c2cbee55-61a6-45ec-bdfd-d26e9ade89ed'  }
    response_body = requests.get('https://api.discover.com/dci-offers/v2/offers', headers = headers)
    return(json.dumps(response_body.text), 200)




if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0", port=8080, use_reloader = False, threaded = True)




