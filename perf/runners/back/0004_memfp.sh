#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

ODIR=$1
work=$(basename $(dirname $(dirname $ODIR)))
work_category=$(basename $(dirname $(dirname $(dirname $ODIR))))
if [ "$work_category" = "parsec3" ] && [ "$work" = "raytrace" ]
then
	work="rtview"
elif [ "$work_category" = "ycsb" ]
then
	work="dbtest"
elif [ "$work_category" = "mysql" ]
then
	work="mysqld"
elif [ "$work_category" = "masim" ]
then
	work="masim"
fi

while true;
do
	pid=`pidof $work`
	if [ $pid ]
	then
		ps -o vsz=,rss=,pid=,cmd= --pid `pidof $work` >> $1/memfps
	fi
	sleep 1
done
