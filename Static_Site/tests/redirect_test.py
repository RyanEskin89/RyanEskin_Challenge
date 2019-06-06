#!/usr/bin/env python3
import requests

#Get the http site for a response
domain = input("Input http domain: ")
r = requests.get(domain)
redir = False

for responses in r.history:
    if ("301" in str(responses)):
        redir=True
    else:
        pass

if redir:
    print("Test Passed")
else:
    print("Test Failed")