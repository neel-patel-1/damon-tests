#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

EXPERIMENTS=`dirname $BASH_SOURCE`

masim_configs="quick_test"

workloads=""

for w in $masim_configs
do
	workloads+="masim/$w "
done

vars="default_numa migrate"

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

