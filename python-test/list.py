#!/usr/bin/env python3

straw_hat_pirates = ("luffy", "zoro", "nami", "usopp", "sanji", "hopper", "robin", 'franky', 'brook')

op = ["luffy", "zoro", "nami", "usopp", "sanji", "hopper", "robin"]

print("one piece :")
for name in op :
	print(name, ' ', end = '')
print(' ')

while len(op) < len(straw_hat_pirates):
	print("so , anyone else ? ...")
	add = input()
	op.append(add)

print("right answer is :")
for name in straw_hat_pirates :
	print(name, ' ', end = '')
print(' ')
