#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

EXPERIMENTS=`dirname $BASH_SOURCE`

masim_configs="$(ls  -1 ./masim_patterns | sed -e 's/\.cfg//g'  | tr -s '\n' ' ')"

workloads=""

for w in $masim_configs
do
	workloads+="masim/$w "
done

vars="orig prcl plrus ttmo ethp"

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

