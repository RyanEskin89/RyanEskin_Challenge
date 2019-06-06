#!/usr/bin/env python3
__author__ = "Ryan Eskin"
'''
The purpose of this script is to verify CC Numbers for ABCD Bank:
https://www.hackerrank.com/challenges/validating-credit-card-number/problem
'''
#The only library we need, the standard lib regex library
import re
'''
Set the initial variables
'''
amount = int(input("amount: "))
numbers = []
consecutive = (r'(\d)\1{3,}')
matcher = (r'^[4-6][0-9]{15}')

'''
After the initial setting of input via input above, we must check the constraints for amount N where 0<N<100
If amount N is outside of these constraints we repeatedly ask for an amount until one within the constraints is given.
'''
while (amount>100) or (amount<1):
    amount = int(input("amount: "))

#For the amount given, we ask for CC numbers until we reach the amount specified, and for each pass, we append that number to our list for inspection
for i in range(amount):
    numbers.append(input("Number " + str(i+1) + ":"))
    
'''
The final check loop.  For each cc number in our list, we collapse
dashes to remove them, we then first check to see if any single digit repeats 
itself 4 or more times, as length, and starting number are irrelevant in that case.
If that passes, we then use our regex "matcher" to match the credit card number with  the given constraints
If that does not pass, the number must be invalid
'''
for newnum in numbers:
    newnum = (re.sub("-", "", newnum))
    if len((re.findall(consecutive,newnum))) > 0:
        print("Invalid")
    elif (re.match(matcher,newnum))is not None:
        print("Valid")
    else:
        print("Invalid")