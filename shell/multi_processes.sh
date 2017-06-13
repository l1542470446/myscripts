#!/bin/bash

OFS=$IFS
RET=0

dd_sd()
{
    sleep 10;
    echo 'this dd sd';
}

s_command='sh run_process.sh'
p_mask='0xFFFFFFFF'
p_instances=10
p_delay=0
pids=''

while getopts ":d:m:n:" opt; do
    case $opt in
    d)
        p_delay=$OPTARG
    ;;
    m)
        p_mask=$OPTARG
    ;;
    n)
        p_instances=$OPTARG
    ;;
    esac
done

for (( j=0 ; j < $p_instances ; j++ ))
do
    w=$s_command
    #w='date'
    #echo "INSTANCE is $j COMMAND is $w"
    #sleep $p_delay
    taskset $p_mask $w &
    process_id=$!
    pids="$pids:$process_id"


    echo "$(eval taskset -p $p_mask $process_id)"

    affinity_observed=`echo "$(eval taskset -p $process_id)"`
    affinity_observed=`echo $affinity_observed | awk 'BEGIN {FS=": "}{print $2}'`

    #echo "OBSERVED affinity is $affinity_observed"
    affinity_observed=`echo '0x'$affinity_observed`
    #echo "OBSERVED affinity is $affinity_observed"
    printf -v affinity_observed_decimal "%d" "$affinity_observed"
    printf -v affinity_expected_decimal "%d" "$p_mask"
    if [ $p_mask == 0xFFFFFFFF ]
    then
        cpu_count=`grep -c processor /proc/cpuinfo`
        affinity_expected_decimal=$((2**cpu_count-1))
    fi

    if [ "$affinity_observed_decimal" -ne "$affinity_expected_decimal" ]
    then
        echo "[ERROR]:OBSERVED AFFINITY $affinity_observed_decimal and EXPECTED AFFINITY $affinity_expected_decimal do not match"
    else
        echo "[RIGHT]:OBSERVED AFFINITY $affinity_observed_decimal and EXPECTED AFFINITY $affinity_expected_decimal match"
    fi
done


IFS=':'
for p in $pids
do
    if [ "x$p" != "x" ]
    then
        wait ${p}
        rc=$?
        if [ "$rc" -ne "0" ]
        then
            RET=1
            echo "************************************************"
            echo "Process $p exit with non-zero value at time " `date`
            echo "************************************************"
            break
        fi
    fi
done


IFS=$OFS
echo "Return is "$RET
exit $RET
