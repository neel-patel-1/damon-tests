#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

if [ $# -ne 1 ]
then
	echo "Usage: $0 <image output dir>"
	exit 1
fi

ODIR=$1

BINDIR=`dirname $0`
LBX="$(dirname "$0")/../lazybox"
PLOT=$LBX/gnuplot/plot.py

mkdir -p $ODIR

for metric in runtime kdamond_cpu_util memused.avg rss.avg acc_per_sec pgmajfaults psi_mem_full_us
do
    for suffix in pdf png
    do
        OUTPUT_IMG=$ODIR/$metric.$suffix

		YRANGE="[*<-1:1<*]"
		YTITLE="$metric overhead\n(percent)"
		if [ "$metric" = "acc_per_sec" ]; then
			YTITLE="$metric increase\n(percent)"
		fi

        $BINDIR/_pr_overheads.sh avg $metric | \
            $PLOT --type clustered_boxes \
                --xtics_rotate -90 \
                --ytitle "$metric overhead\n(percent)" \
                --yrange "$YRANGE" \
                --xzeroaxis 1  \
                --font "Times New Roman,10" \
                --size 800,600 \
                $OUTPUT_IMG
        if [ $? -ne 0 ]
        then
            echo "'$OUTPUT_IMG' generation failed"
        fi
    done
done
