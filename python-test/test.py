#!/usr/bin/env python3
'''
print("please input two number ...")
print("1st : ", end = '')
a = input()
ai = int(a)
print("2st : ", end = '')
b = input()
bi = int(b)
c = ai + bi
print(a, "+", b, "=", c)
'''
###### list ################################################
'''
meats = ["meat", "beaf", "lamb", "pork", "chicken", "fish"]
fruits = ["fruit", "apple", "peach", "banana", "pear"]
foods = ["rice", meats, fruits]
print("there have", len(foods), "food :")
for food in foods:
    if isinstance(food, list):
        print(food[0], " ", end = '')
    else:
        print(food, " ",end = '')
print("")
print("")
n = len(fruits)
print("there have", n-1, "fruit :")
i = 1
while i < n:
    print(fruits[i], " ", end = '')
    i = i + 1
print("")
print("")
n = len(meats)
print("there have", n-1, "meat :")
j = 1
while j < n:
    print(meats[j], " ", end = '')
    j = j + 1
print("")
'''
#########dict & set#################################################
op = {
'luffy' : 505,
'zoro' : 1111,
'nami' : 703,
'sanji' : 302,
}

print("luffy\'s birthday is ", op['luffy'])
