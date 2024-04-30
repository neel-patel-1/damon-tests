#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

[ -z $CFG ] && echo "setting cfg" && CFG=masim_patterns_config.sh

LBX="$(dirname "$0")/../../lazybox"
rm -fr ./results
sudo $LBX/scripts/zram_swap.sh 4G
from_date=$(date)
time CFG=$CFG ./run.sh
echo "tests ran from $from_date to $(date)"

