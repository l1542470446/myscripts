#!/bin/bash

i=100

while [ $i -gt 0 ];do
	printf "%-3d\r" $i
	let "i=$i-1"
	sleep 1
done
