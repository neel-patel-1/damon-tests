#!/bin/bash

# $1: <...>/results/<exp>/<variance>/0(0-9)
bindir=$(dirname "$0")
odir=$1
var=$(basename $(dirname "$odir"))

if [ "$var" != "default_numa" ] 
then
	exit 0
fi

"$bindir/_numa_default_balance.sh"
