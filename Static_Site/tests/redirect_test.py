#!/usr/bin/env python3
import requests

#Get the http site for a response
domain = "http://ryaneskin.com"
r = requests.get(domain)
redir = False

#Requests.history returns a list of redirect responses, we dig through looking for a 301, if we do not find one, redir remains false and the test fails
for responses in r.history:
    if ("301" in str(responses)):
        redir=True
    else:
        pass

if redir:
    print("Redirect to HTTPS exists, Pas")
else:
    print("Test Failed")