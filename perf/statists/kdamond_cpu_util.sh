#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

if [ $# -lt 2 ]
then
	echo "Usage: $0 <output directory> <src directory [src directory ...]>"
	exit 1
fi

LBX="$(dirname "$0")/../../lazybox"

ODIR=$1
SDIR=${@:2}

for stat in avg min max stdev
do
	STATDIR=$ODIR/$stat
	mkdir -p $STATDIR

	f=kdamond_cpu_util
	paths=""
	for d in $SDIR
	do
		paths+=$d/$f" "
	done

	$LBX/scripts/report/statof.py $stat $paths > $STATDIR/$f
done
