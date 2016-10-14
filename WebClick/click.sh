#!/bin/sh

url=""
i=0
#echo -n "click : \r"
while [ $i -lt $1 ]
do
    i=$( expr $i + 1 )
    echo "click : $i"
    tmp=''
    cat url.db | while read url
    do
        tmp=$( echo $url | grep -E -v "^#" )
        #echo "tmp : $tmp"
        if [ ! -z $tmp ] ; then
            #curl -s $url > /dev/null
            echo "click $i --> $url"
            sleep 1
        fi
        #let "i=$i+1"
    done
done

echo "\nclick done!"
