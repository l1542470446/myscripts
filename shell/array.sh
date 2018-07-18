#!/bin/bash

all=`find`
#echo $all

for a in $all
do
	if [ -f $a ];then
		echo $a
	fi
done
