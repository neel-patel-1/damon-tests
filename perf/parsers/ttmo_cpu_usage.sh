#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

input_file=$1/ttmo_cpu_usage
out_file=$2/ttmo_cpu_util

if [ $(wc -l < "$input_file") = "0" ]
then
	tmo_cpu_util="0"
else
	tmo_cpu_util=$(tail -n 1 "$input_file" | awk '{print $1 * 100}')
fi
echo "tmo_cpu_util: $tmo_cpu_util" > "$out_file"

