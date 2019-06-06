#!/usr/bin/env python3
import requests

#Get the https site for a response
domain = "https://ryaneskin.com"
r = requests.get(domain)


#If we get a 200 okay response, the test passes
if (r.status_code == 200):
    print("HTTPS Response Valid for Domain")
else:
    print("HTTPS Response Invalid, Domain down")