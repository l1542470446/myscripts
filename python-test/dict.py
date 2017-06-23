#!/usr/bin/env python3

print("=============dict test===============")
classmates = {"ming" : 89 , "hong" : 70, "liang" : 66}

print("ming`s score is" ,classmates['ming'])

classmates['xing'] = 99

print("xing`s score is", classmates['xing'])
print("liang`s score is", classmates['liang'])

print("=============set test===============")
a = set([1, 2, 3, 4, 4, 5])
print("a =", a)
b = set([3, 4, 7, 8, 9])
print("b =", b)
c = set([10, 15, 20, 31, 64, 88])
print("c =", c)
temp = a & b
print("a & b =", temp)
temp = a & c
print("a & c =", temp)
temp = a | b
print("a | b =", temp)
temp = c | b
temp = sorted(temp)
print("b | c =", temp)
temp = a - b
print("a - b =", temp)
temp = b - a
temp = sorted(temp)
print("b - a =", temp)
