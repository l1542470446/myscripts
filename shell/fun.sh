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

fun()
{

  echo "arg number : $#"
  i=1
  for a in $@
  do
    echo "arg $i : $a"
    i=$(expr $i + 1)
  done
}

sdwrtest()
{
    echo $1
    i=1
    while [ $i -le $1 ]
    do
        echo  test$i.txt a$i
        i=$(expr $i + 1  )
    done
}

test
echo "===="
test1 1
echo "===="
test1 "a"
echo "===="
test1 1 2
echo "===="
test1 "a" "b"
echo "===="
