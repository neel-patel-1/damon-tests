#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

if [ $# -ne 1 ]
then
	echo "Usage: $0 <image output dir>"
	exit 1
fi

ODIR=$1

BINDIR=`dirname $0`
LBX="$(dirname "$0")/../../lazybox"
PLOT=$LBX/gnuplot/plot.py

mkdir -p $ODIR

for metric in runtime kdamond_cpu_util memused.avg rss.avg
do
	for suffix in pdf png
	do
		OUTPUT_IMG=$ODIR/$metric.$suffix
		$BINDIR/_pr_overheads_no_avg.sh avg $metric | \
			$PLOT --type clustered_boxes \
				--xtics_rotate -90 \
				--ytitle "$metric overhead\n(percent)" \
				--yrange "[-100:100]" \
				--xzeroaxis 1  \
				--font "Times New Roman" \
				$OUTPUT_IMG
		if [ $? -ne 0 ]
		then
			echo "'$OUTPUT_IMG' generation failed"
		fi
	done
done
