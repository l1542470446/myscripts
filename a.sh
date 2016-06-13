#!/bin/bash
#abc=0
#echo "bbbbbbbbb"
#if [[ $abc = 1 ]]
#then
#	echo "aaaaaaaaaaa"
#fi

a=(1 2 3 4)
b=(5 6 7 8)

c="${a[*]} ${b[*]}"

fun()
{
	local la=$1
	local s1=1
	#echo $1 $2
	echo $la
	#echo $la[0] $la[1]
	la1=$(echo $la | awk '{print $($s1)}')
	la2=$(echo $la | awk '{print $2}')
	la3=$(echo $la | awk '{print $3}')
	la4=$(echo $la | awk '{print $4}')
	echo $la1
	echo $la2
	echo $la3
	echo $la4

}

fun "${c[*]}"
