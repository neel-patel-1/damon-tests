#!/bin/bash
ODIR=$1
work_category=$(basename $(dirname $(dirname $(dirname $ODIR))))
DAMO_PATH=$(realpath ../../damo/damo)
cd "$ODIR"
PID=""
while [[ -z $PID ]]; do
    PID=$(pidof $work_category)
    sleep 1
done
sudo $DAMO_PATH record --target_pid $PID
