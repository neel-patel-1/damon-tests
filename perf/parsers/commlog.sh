#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

RAW_ODIR=$1
work_category=$(basename $(dirname $(dirname $(dirname $RAW_ODIR))))

if [ "$work_category" == "parsec3" ] || [ "$work_category" == "splash2x" ] || [ "$work_category" == "masim" ]
then
	# input is in format of: 'real    0m50.592s'
	runtime=$(grep -e '^real' $1/commlog | sed 's/^real//' | \
		awk -F'[ms]' '{print $1 * 60 + $2}')
	echo "runtime: $runtime" > $2/runtime
elif [ "$work_category" == "ycsb" ]
then
	trx_per_sec=$(cat "$1/commlog" | awk '{print $1}')
	# time for 1 million transactions in msec
	runtime=$(awk -v t=$trx_per_sec 'BEGIN {print 1000 * 1000000 / t}')
	echo "runtime: $runtime" > $2/runtime
fi
if [ "$work_category" == "masim" ]
then
	acc_per_sec=$( grep accesses $1/commlog | grep -Eo '[0-9]+ accesses/msec' | awk '{sum+= $1} END{print sum/NR}' )	
	echo "accesses_per_ms: $acc_per_sec" > $2/acc_per_sec
fi
