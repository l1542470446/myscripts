#!/bin/sh


mkdir cgroup
sleep 1000000 < cgroup &
rmdir cgroup
