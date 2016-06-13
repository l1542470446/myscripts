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
d="(10 11 12 13)"

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

funb()
{
	local la=$(echo $1)
	echo "funb:$1"
	echo "la[0]=${la[0]}"
}

func()
{
	local la=($1)
	echo "func 1 :$1"
	echo "la[0]=${la[0]}"
	echo "la[1]=${la[1]}"
	local lb=($2)
	echo "func 2 :$2"
	echo "lb[0]=${lb[0]}"
	echo "lb[1]=${lb[1]}"
}

echo '------------------'
fun "${c[*]}"
echo ${a[1]}
echo "d=$d"
echo '------------------'
funb "$d"
echo '------------------'
func "${a[*]}" "${b[*]}"

