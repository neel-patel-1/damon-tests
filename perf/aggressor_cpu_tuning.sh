#!/bin/bash

kdamond_cpu=100
target_cpu=100

do_tuning=0

if [ $do_tuning -eq 1 ]; then
	echo "Time kdamond target" | tee $log_file
	log_file=feedback-auto-tuning.txt
else
	echo "Time kdamond" | tee $log_file
	log_file=no_auto-tuning.txt
fi

# Generate values for a certain number of steps
while [ "1" ] ; do
	for step in $(seq 0 100); do
		target_cpu=$(( 50 * 1000 ))
		kdamond_cpu=$( echo "$(top -b -n 2 -d 1 -p `pgrep kdamond.0` | tail -1 | awk '{print $9}' ) * 1000"  | bc | sed -E 's/\.[0-9]+//g'  ) 
		
		# Print the value
		time=$(date +"%s")
		if [ $do_tuning -eq 1 ]; then
			echo $time $kdamond_cpu $target_cpu | tee -a $log_file
			echo $target_cpu | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/schemes/0/quotas/goals/0/target_value ;
			echo $kdamond_cpu | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/schemes/0/quotas/goals/0/current_value;
			echo commit_schemes_quota_goals | sudo tee /sys/kernel/mm/damon/admin/kdamonds/0/state
		else
			echo $time $kdamond_cpu | tee -a $log_file
		fi

	done
done
