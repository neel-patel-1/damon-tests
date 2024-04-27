#!/bin/bash

set -e


bindir=$(dirname "$0")
repos_dir=$(realpath "$bindir/../../")

# rsync is required for remote results fetching
sudo apt install -y rsync
# pstree is required by lazybox
sudo apt install -y psmisc


# Install PARSEC3/SPLASH-2X
cd "$repos_dir"
if [ ! -d parsec-benchmark ]
then
	git clone https://github.com/damonitor/parsec-benchmark
else
	git -C parsec-benchmark fetch origin
	git -C parsec-benchmark checkout origin/master
fi
cd parsec-benchmark
./configure
./get-inputs -n
bash -c "source env.sh && parsecmgmt -a build"
