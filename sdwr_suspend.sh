#!/bin/sh

OFS=$IFS
start_date=0
now_date=0
current_time=0
final_time=0
test_time=1200 #144000,72000,36000,10800,7200,3600,1200,600
RET=0
pids=''

sdwr()
{
    if [ ! -d $2 ]; then
      mkdir $2
    fi

    while [ $current_time -lt  $final_time ];do
        current_time=$(date "+%s")
        echo "---sdwr $1--- current time : $current_time" | tee -a /data/ioblock/iotest.log

        sh -c "dd if=/dev/zero of=$1 bs=100m count=10 2>/dev/null && sync"
        sh -c "mv $1 /dev/null && sync"

        if [ -d $2 ]; then
            mv $2 dup$2
        elif [ -d $2dup ]; then
            mv dup$2 $2
        fi
        sync

        if [ -f /data/$1 ] ;then
            rm /data/$1
        fi
        if [ -f $1 ] ;then
            rm $1
        fi
    done

    if [ -d $2 ]; then
        rm -r $2
    fi
    if [ -d dup$2 ]; then
        rm -r dup$2
    fi
}

suspend_wr()
{
    while [ $current_time -lt  $final_time ];do
        now_date=$(date "+%H:%M:%S")
        echo "---suspend--- time schedule : $start_date-$now_date" | tee -a /data/ioblock/iotest.log

        i=0
        echo -e "wr_suspend_test start:\c"
        while [ $i -lt 50 ] ; do
            echo -e "T\c"
            sh -c "dd if=/dev/zero of=btest$i.txt bs=100m count=10 2>/dev/null && sync"
            /data/ioblock/rtcwake -d /dev/rtc0 -m "mem" -s 2 > /dev/null 2>&1
            let "i=$i+1"
        done
        i=0
        echo -e "\nwr_suspend_test clear:\c"
        while [ $i -lt 50 ] ; do
            sh -c "mv btest$i.txt /dev/null && sync"
            echo -e "C\c"
            let "i=$i+1"
        done
        echo -e "\nwr_suspend_test stop"

        current_time=$(date "+%s")
    done
}

suspend()
{
    while [ $current_time -lt  $final_time ];do
        current_time=$(date "+%s")
        now_date=$(date "+%H:%M:%S")
        echo "---suspend--- time schedule : $start_date-$now_date" | tee -a /data/ioblock/iotest.log
        sleep 6
        /data/ioblock/rtcwake -d /dev/rtc0 -m "mem" -s 2
    done
}

sdwrtest()
{
    i=1
    while [ $i -le $1 ]
    do
        sdwr test$i.txt a$i &
        process_id=$!
        pids="$pids:$process_id"
        echo "---process $process_id run : sdwr test$i.txt a$i" | tee -a /data/ioblock/iotest.log
        let "i=$i+1"
    done
}

if [ -f /data/ioblock/iotest.log ] ; then
    rm /data/ioblock/iotest.log
fi

echo "---###---io block test start"
cd /sdcard

current_time=$(date "+%s")
start_date=$(date "+%H:%M:%S")
echo "---###---current time : $current_time"
let "final_time=$current_time+$test_time"

#sdwrtest 25
#suspend &
suspend_wr &

pids="$pids:$!"
IFS=':'
pronum=0
for p in $pids
do
    if [ "x$p" != "x" ]
    then
        let "pronum=$pronum+1"
        wait ${p}
        rc=$?
        if [ "$rc" -ne "0" ]
        then
            RET=1
            echo "---###---$pronum:Process $p exit with non-zero value at time : $(date "+%H:%M:%S") " | tee -a /data/ioblock/iotest.log
            break
        fi
        echo "---###---$pronum:Process $p exit successfully at time : $(date "+%H:%M:%S") " | tee -a /data/ioblock/iotest.log
    fi
done
IFS=$OFS

echo "---###---final time : $final_time"
if [ $RET -eq 0 ]; then
    echo "---###---test done"
else
    echo "---###---test fail"
fi

exit $RET
