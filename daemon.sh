#!/bin/bash

root=~/gartenctrl/
source $root/ctrllib.sh

cd $root

python ctrl.py | grep -v "ID Read" | tee $root/daemon.tmp

printf "mystrom-grid\t" | tee -a $root/daemon.tmp
curl -s http://192.168.1.10/report | tee -a $root/daemon.tmp
echo | tee -a $root/daemon.tmp
printf "mystrom-charger\t" | tee -a $root/daemon.tmp
curl -s http://192.168.1.197/report | tee -a $root/daemon.tmp
echo | tee -a $root/daemon.tmp
printf "date\t" | tee -a $root/daemon.tmp
date | tee -a daemon.tmp

mv $root/daemon.tmp $root/daemon.out

