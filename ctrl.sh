#!/bin/bash

root=~/gartenctrl/

mystrom_gridinverter=192.168.1.10

v1=`cat $root/daemon.out | grep "2-ADC" | cut -f 4`
v0=30
i1=`cat $root/daemon.out | grep "1-ADC" | cut -f 4`
i0=`cat $root/daemon.out | grep "0-ADC" | cut -f 4`

p1=`echo "$v1*$i1"| bc -l`
p0=`echo "$v0*$i0"| bc -l`
#echo $p1

printf "v0=%1.1f\ti1=%1.1f\tp1=%1.1f\n" $v0 $i0 $p0
printf "v1=%1.1f\ti1=%1.1f\tp1=%1.1f\n" $v1 $i1 $p1
#   i1=$i1   p1=$p1

if (( $(echo "$v1 > 22" |bc -l) )); then
    echo load on
    curl -s http://${mystrom_gridinverter}/relay?state=1
    exit 0
fi

if (( $(echo "$v1 < 19" |bc -l) )); then
    echo load off
    curl -s http://${mystrom_gridinverter}/relay?state=0
    exit 0
fi

echo load unchanged

