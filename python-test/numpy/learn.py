#!/usr/bin/env python

import os
import sys
import wave
import numpy as np

if __name__ == '__main__':
    print 'learn numpy'
    a1 = [1,2,3,4,5,7,8,9,5,4,2,56,8,4,4,8,5,1,5,45]
    np_a1 = np.array(a1)
    np_a1.shape = ( 10, 2)
    print np_a1.shape
    print np_a1
    print 'string numpy'
    str1=["aa", 'bb', 'cc', 'dd', 'ee', 'ff', 'gg', 'hh', 'ii', 'jj']
    np_str1=np.array(str1)
    np_str1.shape=(2,5)
    print np_str1.shape
    print np_str1
