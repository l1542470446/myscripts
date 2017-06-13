#!/bin/sh

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

#sdwrtest 5

#itouch aaa bbb
var1="1,2"
var="aaa bbb $var1"
fun $var
