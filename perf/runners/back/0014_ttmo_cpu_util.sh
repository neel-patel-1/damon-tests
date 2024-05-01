#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

if [ "$EUID" -ne 0 ]
then
	echo "run as root"
	exit 1
fi

if [ $# -ne 1 ]
then
	echo "Usage: $0 <output dir>"
	exit 1
fi

odir=$1
var=$(basename $(dirname "$odir"))

cpu_usage_file=$1/kdamond_cpu_usage
rm -f "$cpu_usage_file"
touch "$cpu_usage_file"

if [ "$var" != "ttmo" ]
then
	exit 0
fi

ttmo_pid=""
pids=$(pgrep -f '_ex_ttmo.sh')

while [ -z "$ttmo_pid" ] 
do
	sleep 1
	echo "Checking for _ttmo.sh process..."
	ttmo_pid=$(pgrep -f _ex_ttmo.sh) 
done

for pid in $pids; do
    if ps -p $pid -o state --no-headers | grep -qv 'Z'; then
 #       echo "Active PID: $pid"
	ttmo_pid=$pid
    fi
done

#echo "_ex_ttmo.sh is running with PID: $ttmo_pid"

echo "monitor ttmo ($ttmo_pid)"
stat_file="/proc/$ttmo_pid/stat"
start_total_jiffies=$(cat /proc/timer_list | grep "^jiffies: " --max-count=1 | awk '{print $2}')
start_process_jiffies=$(cat "$stat_file" | awk '{print $15}')

while [ -f "$stat_file" ]
do
	sleep 1

	now_total_jiffies=$(cat /proc/timer_list | grep "^jiffies: " --max-count=1 | awk '{print $2}')
	now_process_jiffies=$(cat "$stat_file" | awk '{print $15}')
	if ! [ -f "$stat_file" ]
	then
		break
	fi

	total_jiffies=$((now_total_jiffies - start_total_jiffies))
	process_jiffies=$((now_process_jiffies - start_process_jiffies))
	process_util=$(echo "$process_jiffies $total_jiffies" | awk '{print $1 / $2}')

	echo "$process_util $process_jiffies $total_jiffies" >> "$cpu_usage_file"
done