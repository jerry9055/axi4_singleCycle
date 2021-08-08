#!/bin/bash

ISA=riscv64
####### mycpu ######
CMP_SRC=mycpu
# CPUTEST_PATH=/home/lary/Documents/gitcode/ysyx/am-kernels/tests/cpu-tests #cpu-test
CPUTEST_PATH=/home/lary/Documents/gitcode/ysyx/riscv-tests #riscv-test

####### nutshell ###
# CMP_SRC=nutshell
# CPUTEST_PATH=/home/lary/Documents/gitcode/oscpu/nexus-am/tests/cputest


files=`ls $CPUTEST_PATH/build/*-$ISA-$CMP_SRC.bin`
ori_log="build/$CMP_SRC-log.txt"

for file in $files; do
  base=`basename $file | sed -e "s/-$ISA-$CMP_SRC.bin//"`
  printf "[%14s] " $base
  logfile=$base-log.txt
  # make run DIFF=1 TEST=$base &> $logfile  #cpu-test
  make run DIFF=1 RVTEST=$base &> $logfile  #riscv-test

  if (grep 'nemu: .*HIT GOOD TRAP' $logfile > /dev/null) then
    echo -e "\033[1;32mPASS!\033[0m"
    rm $logfile
  else
    echo -e "\033[1;31mFAIL!\033[0m see $logfile for more information"
    if (test -e $ori_log) then
      echo -e "\n\n===== the original log.txt =====\n" >> $logfile
      cat $ori_log >> $logfile
    fi
  fi
done
