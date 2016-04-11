#!/bin/sh

dir_name="/home/apuser/Workspace/Repo/sprdroid6.0_trunk_k318_dev/sprdisk/ltp-ddt/runtest/ddt/"
#dir_name="/home/apuser/sprdroid6.0_trunk_k318_dev/"
all=$(ls -l ${dir_name} | grep ^[^d] | awk '{print $9}')

if [ -f csv.csv ];then
	rm csv.csv
fi

touch csv.csv

for i in $all
do
	requ=$(cat ${dir_name}$i | sed -n '/^# @requires/p' | cut -c13-)
 	cat ${dir_name}$i | sed '/^#/d' | sed '/^$/d' | while read line
	do
		oneline=$(echo "$line" | cut -d" " -f1)
		comd=$(echo "$line" | cut -d" " -f2-)
		tag1=$(echo "$oneline" | cut -d"_" -f1)
		tag2=$(echo "$oneline" | cut -d"_" -f2)
		tag3=$(echo "$oneline" | cut -d"_" -f3)
		tag4=$(echo "$oneline" | cut -d"_" -f4-)
		list1="$tag1,$tag2,$tag3,$tag4,$i,$requ,$comd"
		echo $list1 >> csv.csv
	done
done
