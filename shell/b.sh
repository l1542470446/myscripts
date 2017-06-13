#!/bin/bash

#fmem='echo "$(eval free -m | sed 's/ \+/ /g' | grep "Mem" | cut -d " " -f 4)"'
fmem=$( free -m | sed 's/ \+/ /g' | grep "Mem" | cut -d " " -f 4 )
#fmem='date'
pnum=$( echo "($fmem-200)/40" | bc )
echo $fmem
echo $pnum
#a=123
#echo $a
