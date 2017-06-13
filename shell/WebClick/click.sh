#!/bin/sh

echo "usage : ./click [file-name] [click-count]"

url=""
i=0

urldb=$1
clkcount=$2

#echo -n "click : \r"
while [ $i -lt $clkcount ]
do
    j=1
    i=$( expr $i + 1 )
    echo "click : $i/$clkcount"
    tmp=''
    cat $urldb | while read url
    do
        tmp=$( echo $url | grep -E -v "^#" )
        #echo "tmp : $tmp"
        if [ ! -z $tmp ] ; then
            curl -s $url > /dev/null
            echo "web$j --> $url"
            sleep 1
	    j=$( expr $j + 1 )
	fi
        #let "i=$i+1"
    done
done

echo "\nclick done!"
