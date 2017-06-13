#!/bin/sh

FIND=false

echo $FIND
i=0
while [ $i -lt 5 ]
do
    FIND=$(echo true)
	echo $FIND
	i=$(expr $i + 1)
done

echo $FIND
