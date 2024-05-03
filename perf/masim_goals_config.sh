#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

EXPERIMENTS=`dirname $BASH_SOURCE`

masim_configs="stairs 100mb"
masim_configs="$(ls  -1 ./masim_patterns | sed -e 's/\.cfg//g'  | tr -s '\n' ' ')"

workloads=""

for w in $masim_configs
do
	workloads+="masim/$w "
done

vars="orig "
quota_ms=( 1 10 25 100 1000 )
for num in ${quota_ms[@]}; do 
	[ ! -d schemes/prcl_quota_${num}ms.json ] && sed "s/\"time_ms\": \"1 s\"/\"time_ms\": \"$num ms\"/g" schemes/prcl_quota.json > schemes/prcl_quota_${num}ms.json ; 
	vars+="prcl_quota_${num}ms "
done 

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
