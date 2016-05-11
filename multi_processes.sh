#!/bin/bash

s_command='sleep 10'
p_mask='0xFFFFFFFF'
p_instances=1
p_delay=0

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
    echo "INSTANCE is $j COMMAND is $w"
    sleep $p_delay
    taskset $p_mask $w &
    process_id=$!
    echo "$(eval taskset -p $p_mask $process_id)"
    affinity_observed=`echo "$(eval taskset -p $process_id)"`
    affinity_observed=`echo $affinity_observed | awk 'BEGIN {FS=": "}{print $2}'`
    echo "OBSERVED affinity is $affinity_observed"
    affinity_observed=`echo '0x'$affinity_observed`
    echo "OBSERVED affinity is $affinity_observed"
    printf -v affinity_observed_decimal "%d" "$affinity_observed"
    printf -v affinity_expected_decimal "%d" "$p_mask"
    if [ $p_mask == 0xFFFFFFFF ]
    then
        cpu_count=`grep -c processor /proc/cpuinfo`
        affinity_expected_decimal=$((2**cpu_count-1))
    fi
    echo "OBSERVED AFFINITY is $affinity_observed_decimal and EXPECTED AFFINITY is $affinity_expected_decimal"
    if [ "$affinity_observed_decimal" -ne "$affinity_expected_decimal" ]
    then
        echo "[ERROR]:OBSERVED AFFINITY $affinity_observed_decimal and EXPECTED AFFINITY $affinity_expected_decimal do not match"
    fi
done
