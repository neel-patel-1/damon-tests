#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

EXPERIMENTS=`dirname $BASH_SOURCE`

parsec_workloads="blackscholes bodytrack canneal dedup facesim "
parsec_workloads+="fluidanimate freqmine raytrace streamcluster swaptions "
parsec_workloads+="vips"
#parsec_workloads="blackscholes "

workloads=""
for w in $parsec_workloads
do
	workloads+="parsec3/$w "
done
vars="orig prcl ttmo"

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
REPEATS=3
