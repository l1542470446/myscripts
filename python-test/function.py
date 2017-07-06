#!/usr/bin/env python3

def find_prime(x) :
    prime = [1]
    if x < 3 :
        return prime
    elif x <= 4 :
        prime.append(3)
    else :
        for j in range(3,x+1) :
            p = 0
            for i in range(2, int(j/2)) :
                if  j % i == 0 :
                    p = 1
                    break
            if p == 0 :
                prime.append(j)
        prime.pop(2)
    return prime

def print_number(val) :
    n = 1
    for i in val :
        print(i, '  ',end = '')
        n = n + 1
        if n == 10 :
            n = 1
            print(' ')
    print(' ')


x = 70
a = find_prime(x)
print_number(a)
