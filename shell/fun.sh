#!/bin/bash

function test()
{
	echo "test fun : 1st example"
}

function test1()
{
	echo "test argc  : $#"
	if [ -n "$1" ];then
		echo "test args 1: $1"
	fi
	if [ -n "$2" ];then
		echo "test args 2: $2"
	fi
}

function fun1()
{
	return 2
}

function fun2()
{
	echo "function test"
	echo "bb"
	echo "aa"
	return 33
}

echo "===="
test
echo "===="
test1 1
echo "===="
test1 "a"
echo "===="
test1 1 2
echo "===="
test1 "a" "b"
echo "====test1 fun return val===="
fun1
ret=$?
echo $ret
echo "====test2 fun return val===="
val=`fun2`
ret=$?
echo "val = $val"
echo "ret = $ret"
