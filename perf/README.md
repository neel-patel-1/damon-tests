Reproducing Results from "Evaluating Data Access Pattern Aware Memory Management"
```
Quota Sweep Plots: 
---
results directory: masim_quota_sweep_results CFG
config: masim_goals_config.sh
reports directory: masim_quota_sweep_reports

Generating report:
sudo ODIR_ROOT=$PWD/masim_quota_sweep_results CFG=masim_goals_config.sh ./mk_reports_to.sh masim_quota_sweep_reports

Microbenchmark Plots:
---
results directory: masim_results
config: masim_patterns_config.sh
reports directory: masim_micro_reports

Time to Convergence Feedback Autotuning Plot:
---
#terminal 1
n869p538@ubuntu:perf$ sudo ./../../damo/damo schemes "../../masim/masim ../../masim/configs/10GB.cfg --repeat 100 " --damos_action pageout --damos_access_rate 0% max --damos_age 0s max --damos_quotas 1000ms 10GiB 1s --damos_quota_goal user_inpu
# terminal 2
n869p538@ubuntu:perf$ ./aggressor_cpu_tuning.sh

#run once without tuning and once with tuning by modifying the aggressor_cpu_tuning.sh script which tracks the cpu utilization for you
---

```

This directory contains files for the performance test of DAMON.

The test measures the runtime and memory footprint of various workloads with
different kernel configurations.  The configurations are as below:

    orig	Original kernel running THP with 'madvise()' enable policy
    rec		Kernel running DAMON with record option for the workloads
    prec	Kernel running DAMON with record option for the system
    thp		Original kernel running THP with 'always' enable policy
    ethp	Kernel running 'efficient THP' operation scheme.
    prcl	Kernel running 'proactive reclamation' operation scheme for the workloads.
    pprcl	Kernel running 'proactive reclamation' operation scheme for the system.

The workloads are:

- 24 workloads in PARSEC3[1] and SPLASH-2X[2], and
- 4 YCSB workloads having different zipfian distribution.

[1] https://parsec.cs.princeton.edu/parsec3-doc.htm
[2] https://parsec.cs.princeton.edu/parsec3-doc.htm#splash2x


Pre-requisites
==============

setup.sh
--------

Run setup.sh on this directory.  It clones necessary repositories, install
linux kernel with appropriate configs, and setup PARSEC3/SPLASH-2X benchmarks.
You may modify the script before running if you want to have a customized
environment or want to skip some of the setup stesp such as PARSEC3/SPLASH-2X
setup.


silo
----

The tests use a variant of YCSB-A workload which is implemented on a DB storage
system, silo[1].  The implementation uses objects smaller than the original
YCSB and does uniformly distributed requests, while the original YCSB uses
a zipfian distribution with alpha value 0.99.  To test DAMON against more
original-like YCSB workloads with various access patterns, users should install
silo at '$HOME/silo' with 'patches/silo.patch'.  For example, assuming
'$DAMON_TESTS' contains the place of 'damon-tests' directory:

    $ cd $HOME; git clone https://github.com/stephentu/silo.git
    $ cd silo; git am $DAMON_TESTS/perf/patches/silo.patch
    $ make -j dbtest

[1] https://github.com/stephentu/silo.git
[2] https://github.com/brianfrankcooper/YCSB
[3] https://github.com/brianfrankcooper/YCSB/blob/0a330744c5b6f3b1a49e8988ccf1f6ac748340f5/core/src/main/java/com/yahoo/ycsb/generator/ZipfianGenerator.java#L42


Python3
-------

Lazybox depends on Python3.  Install it using your package manager.  However,
most python scripts in the lazybox are python2 compatible.   You could try
changing the shebangs to python2.


gnuplot
-------

Visualization of the outputs in the reports is made using 'gnuplot'.  Install
it using your package manager.


HOWTO
=====

This section describes how you can run the tests and make a report on your
system.  Before the below instructions, please ensure that your system meets
the above-mentioned pre-requisites.

Just sequentially execute below three commands.

    $ CFG=full_config.sh ./full_run.sh
    $ CFG=full_config.sh ./post.sh
    $ CFG=full_config.sh ./mk_reports.sh

The first command runs the workloads and measures some metrics.  It would take
more than 10 hours.  The second command does the post-processing of the numbers
gathered during the runs.  The final command generates the reports for you and
shows a summary in text form.  It generates a detailed report in text form, and
in html form in 'report/report.txt' and 'report/html/index.html', respectively.
The html form report includes simple visualizations of the output, either.  The
visualizations are also available in 'report/plots/' directory.

To run masim microbenchmarks and specify report output directory using results.
    $ sudo CFG=masim_patterns_config.sh ./masim_run.sh
    $ sudo ODIR_ROOT=$PWD/masim_results CFG=masim_patterns_config.sh ./post.sh
    $ sudo ODIR_ROOT=$PWD/masim_results CFG=masim_patterns_config.sh ./mk_reports_to.sh masim_reports


Results from paper:
Fig (Quota Microbenchmark Sweep)
n869p538@castor:perf$ git add masim_quota_sweep_results/
n869p538@castor:perf$ git add masim_reports_quota_sweep_results/
