
#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

rm -fr ./results
sudo ~/lazybox/scripts/zram_swap.sh 4G
from_date=$(date)
time CFG=test_config.sh ./run.sh
echo "tests ran from $from_date to $(date)"
