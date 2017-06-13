#!/bin/sh

if [ -f read.txt ]
then
rm read.txt
fi

touch read.txt

while IFS=: read user pass uid gid fullname homedir Shell
do
	a="user=$user,pass=$pass,uid=$uid,gid=$gid,fullname=$fullname,homedir=$homedir,Shell=$Shell"
	echo $a >> read.txt
done < /etc/passwd
