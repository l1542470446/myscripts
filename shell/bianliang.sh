#!/bin/bash

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

j=1
a="bb"
a1="a1"
eval "echo $a1"
eval "echo \$a$j"
