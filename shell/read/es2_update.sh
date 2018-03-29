#!/system/bin/sh

temp=""
tran=""
sn=""
count=0
flag=0

rm -rf /cache/*
source /system/bin/fat.sh

# 1. upgrade uboot
if [ -f /storage/uboot.img ]; then
	cp /storage/uboot.img /cache
	sync
	sleep 1
	dd if=/cache/uboot.img of=/dev/block/rknand_uboot
	echo "write uboot OK!"
fi

# 2. fix S/N
temp=`GetEnvCustom S/N | grep S/N | busybox cut -d "=" -f 2`
if [ -f /storage/sn-map ]; then
	cp /storage/sn-map /cache
	sleep 1
	while read line 
	do
		tran=${line:0:15}
		sn=${line:16}
		if [ "${temp}" = "${tran}" ]; then
			echo "find right SN"
			flag=1
			break
		fi
	done < /cache/sn-map
	if [ ${flag} -eq 0 ]; then
		sn=${temp}
	fi
	fw_setenv product_serialnumber ${sn}
	fw_setenv S/N ${sn}
	echo "sn=${sn}"
fi

# 3. led tip
LedTest
audio_test /system/etc/audiofiles/Ringtone.wav -D 0 -d 0 -P -p 4096 -r 48000 -f 16 -c 2 -n 4
exit 0
