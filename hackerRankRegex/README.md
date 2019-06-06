This script is a solution to the following problem:

https://www.hackerrank.com/challenges/validating-credit-card-number/problem

The main methodology for this was broken into 3 parts.

Ensure the amount of CC numbers given is within the constraint provided by the problem at hand.

Take in that many CC numbers

Using regex, remove any dashes in said numbers, (any other delimiter is invalid and as such, provides an invalid result), and ensure they follow the rules:

The number must start with either 4, 5, or 6, be 16 digits total, and no number can repeat itself 4 or more times.