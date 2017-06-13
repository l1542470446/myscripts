#!/bin/sh

if [ -f read0.txt ]
then
rm read0.txt
fi

touch read0.txt

while read pa pb pc
do
	echo $pb >> read0.txt
done < ./readchar.txt
