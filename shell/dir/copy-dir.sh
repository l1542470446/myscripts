#!/bin/bash

count=0
dir_src=""
dir_dst=""

echo $1
echo $2

if [ ! -d $1 ];then
	return 1
else
	dir_src=$1
#	dir_src=`dirname $dir`
	echo "src dir="${dir_src}
fi

if [ ! -d $2 ];then
	return 1
else
	dir_dst=$2
#	dir_dst=`dirname $dir`
	echo "dst dir="${dir_dst}
fi

files=`find . -name "*.mp3"`

echo ${files} | while read -d " " file
do
	var=${file%%/}
	echo "$count - $var"
	let "count=$count+1"
	if [ -f ${dir_src}/${var} ];then
		cp ${dir_src}/${var} ${dir_dst}
	fi
	if [ $count -eq 5 ];then
		break
	fi
done
