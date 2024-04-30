#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

LBX="$(dirname "$0")/../../lazybox"
rm -fr ./results
from_date=$(date)
time CFG=plru_tests_config.sh ./run.sh
echo "tests ran from $from_date to $(date)"

