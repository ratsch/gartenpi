#!/bin/bash

root=~/gartenctrl/

python ctrl.py | grep -v "ID Read" | tee $root/daemon.tmp

printf "mystrom\t" | tee -a $root/daemon.tmp
curl -s http://192.168.1.10/report | tee -a $root/daemon.tmp
echo | tee -a $root/daemon.tmp
printf "date\t" | tee -a $root/daemon.tmp
date | tee -a daemon.tmp

mv $root/daemon.tmp $root/daemon.out
