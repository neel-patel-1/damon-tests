#!/bin/bash

kdamond_cpu=100
target_cpu=100
log_file=convergence_time.txt

echo "Time kdamond target" | tee $log_file

# Generate values for a certain number of steps
while [ "1" ] ; do
	for step in $(seq 0 100); do
		target_cpu=$(( 50 * 1000 ))
		kdamond_cpu=$( echo "$(top -b -n 2 -d 1 -p `pgrep kdamond.0` | tail -1 | awk '{print $9}' ) * 1000"  | bc | sed -E 's/\.[0-9]+//g'  ) 
		
		# Print the value
		time=$(date +"%s")
		echo $time $kdamond_cpu $target_cpu | tee -a $log_file
		echo $target_cpu | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/schemes/0/quotas/goals/0/target_value ;
		echo $kdamond_cpu | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/schemes/0/quotas/goals/0/current_value;
		echo commit_schemes_quota_goals | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/state

	done
done
