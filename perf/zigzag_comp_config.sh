#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

EXPERIMENTS=`dirname $BASH_SOURCE`

masim_configs="zigzag_30secs"

workloads=""

for w in $masim_configs
do
	workloads+="masim/$w "
done

#vars="orig rec prcl prcl_auto_50 plrus plrus_auto_7000 ttmo thp ethp"
vars="orig prcl5s prcl2s "

VARIANTS=""

for v in $vars
do
	for w in $workloads
	do
		VARIANTS+="$w/$v "
	done
done

EXPERIMENTS=$EXPERIMENTS
VARIANTS=$VARIANTS
REPEATS=1

