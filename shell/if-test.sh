#!/bin/bash

a="test"
b="test"
c="test1"

if [ "$a" = "$b" ]; then
	echo "a = b"
fi

if [ "$a" = "$b" ]; then
	echo "a = b"
fi

if [ $a = $c ];then
	echo "a = c"
fi
