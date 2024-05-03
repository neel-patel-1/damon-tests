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

        # Default yrange
        YRANGE="[-100:100]"

        # Adjust yrange based on metric
        case $metric in
            "kdamond_cpu_util")
                YRANGE="[-0.2:1.7]"
                ;;
            "memused.avg")
                YRANGE="[-100:350]"
                ;;
            "rss.avg")
                YRANGE="[-100:85]"
                ;;
            "runtime")
			YRANGE="[-15:15]"
                ;;
			"pgmajfaults")
			YRANGE="[-15:1000000]"
                ;;
			"psi_mem_full_us")
			YRANGE="[-15:12000000]"
                ;;
        esac

        $BINDIR/_pr_overheads.sh avg $metric | \
            $PLOT --type clustered_boxes \
                --xtics_rotate -45 \
                --ytitle "$metric overhead\n(percent)" \
                --yrange "$YRANGE" \
                --xzeroaxis 1  \
                --font "Times New Roman,13" \
                --size 800,600 \
                $OUTPUT_IMG
        if [ $? -ne 0 ]
        then
            echo "'$OUTPUT_IMG' generation failed"
        fi
    done
done

