#!/bin/bash

DEVICE_TYPE="mmc"


SKIP_FORMAT=0
WRITE_TO_FILL=0

compare_md5sum()
{
  FILE1=$1
  FILE2=$2
  a=$(md5sum "$FILE1"|cut -d' ' -f1)
  echo "$1: $a"
  b=$(md5sum "$FILE2"|cut -d' ' -f1)
  echo "$2: $b"
  [ "$a" = "$b" ]
}
############################### CLI Params ###################################

while getopts  :d:f:m:n:b:c:i:l:swh arg
do case $arg in
        n)
                # optional param
                DEV_NODE="$OPTARG";;
        d)      DEVICE_TYPE="$OPTARG";;
        f)      FS_TYPE="$OPTARG";;
        m)      MNT_POINT="$OPTARG"; MNT_POINT="${MNT_POINT}_$$";;
        b)      DD_BUFSIZE="$OPTARG";;
        c)      DD_CNT="$OPTARG";;
        i)      IO_OPERATION="$OPTARG";;
        l)      TEST_LOOP="$OPTARG";;
        s)      SKIP_FORMAT=1;;
        w)      WRITE_TO_FILL=1;;
        h)      usage;;
        :)      test_print_trc "$0: Must supply an argument to -$OPTARG." >&2
                exit 1
                ;;

        \?)     test_print_trc "Invalid Option -$OPTARG ignored." >&2
                usage
                exit 1
                ;;
esac
done

############################ DEFAULT Params #######################
: ${MNT_POINT:=/mnt/partition_${DEVICE_TYPE}_$$}
: ${IO_OPERATION:='wr'}
: ${TEST_LOOP:='1'}

############# Do the work ###########################################
if [ -z $DEV_NODE ]; then
  DEV_NODE=`get_blk_device_node.sh "$DEVICE_TYPE"` || die "error getting device node for $DEVICE_TYPE: $DEV_NODE"
  test_print_trc "DEV_NODE returned from get_blk_device_node is: $DEV_NODE"
fi

# printout mmc ios for mmc test
if [[ "$DEV_NODE" =~ "mmc" ]]; then
  do_cmd printout_mmc_ios
fi
# TODO
sh blk_device_prepare_format.sh -d "$DEVICE_TYPE" -n "$DEV_NODE" -m "$MNT_POINT"


# find out what is FS in the device
if [ -z "$FS_TYPE" ]; then
  FS_TYPE=`mount | grep $DEV_NODE | cut -d' ' -f5 | head -1`
  test_print_trc "Current FS_TYPE: ${FS_TYPE}"
fi

remove_srcfile()
{
  echo "Removing srcfile"
  do_cmd rm "$SRC_FILE"
}

remove_testfiles()
{
  if [ "$WRITE_TO_FILL" -eq 1 ]; then
    echo "Removing test files"
    TEST_FILE="${MNT_POINT}/test_file_$$_*"
    do_cmd "rm ${TEST_FILE}"
  fi
  # umount etc
  [ $SKIP_FORMAT -eq 1 ] || do_cmd blk_device_unprepare.sh -n "$DEV_NODE" -d "$DEVICE_TYPE" -f "$FS_TYPE" -m "$MNT_POINT"
}

# execute on exit - cleanup actions
on_exit()
{
  echo "clean up......."
  remove_srcfile
  remove_testfiles
  echo "done with clean up"
}

trap on_exit EXIT

SRC_FILE="/home/root/srctest_file_${DEVICE_TYPE}_$$"
time dd if=/dev/urandom of=$SRC_FILE bs=$DD_BUFSIZE count=$DD_CNT
sleep 10
do_cmd ls -lh $SRC_FILE
df -h

x=0
while [ $x -lt $TEST_LOOP ]
do
  echo "============R/W LOOP: $x============"
  date
  TEST_FILE="${MNT_POINT}/test_file_$$"

  case $IO_OPERATION in
    wr)
      time dd if="$SRC_FILE" of="$TEST_FILE" bs=$DD_BUFSIZE count=$DD_CNT
      sync
      echo 3 > /proc/sys/vm/drop_caches
      diff "$SRC_FILE" "$TEST_FILE"
      if [ $? -ne 0 ]; then
        cmp -l "$SRC_FILE" "$TEST_FILE"
      fi
      time dd if=$TEST_FILE of=/dev/null bs=$DD_BUFSIZE count=$DD_CNT
      sync
      echo 3 > /proc/sys/vm/drop_caches
    ;;
    *)
    echo "Invalid IO operation type in $0 script"
    exit 1;
    ;;
  esac
  if [ "$WRITE_TO_FILL" -ne 1 ]; then
    rm "$TEST_FILE"
  else
    # don't remove the testfiles so that to fillup the device
    echo "Did not remove the testfiles in order to fillup the device"
  fi
  x=$((x+1))
  date
done

df -h
