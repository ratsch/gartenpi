#!/bin/bash

root=~/gartenctrl/
source $root/ctrllib.sh

gridstate=`curl -s http://${mystrom_gridinverter}/report | jq -r ".relay"` 
chargerstate=`curl -s http://${mystrom_charger}/report | jq -r ".relay"` 

state=`printf "grid=%s\tcharger=%s" "$gridstate" "$chargerstate"`
actionlog "$state" 1

v1=`cat $root/daemon.out | grep "2-ADC" | cut -f 4`
v0=30
i1=`cat $root/daemon.out | grep "1-ADC" | cut -f 4`
i0=`cat $root/daemon.out | grep "0-ADC" | cut -f 4`

p1=`echo "$v1*$i1"| bc -l`
p0=`echo "$v0*$i0"| bc -l`
#echo $p1

o0=`printf "v0=%1.1f\ti1=%1.1f\tp1=%1.1f\n" $v0 $i0 $p0`
o1=`printf "v1=%1.1f\ti1=%1.1f\tp1=%1.1f\n" $v1 $i1 $p1`
actionlog "$o0"
actionlog "$o1"
#   i1=$i1   p1=$p1

if (( $(echo "$v1 > 12.2" |bc -l) )); then
    if [ "$gridstate" == "false" ];
    then
	actionlog "load off->on"
	curl -s http://${mystrom_gridinverter}/relay?state=1
    fi
    curl -s http://${mystrom_charger}/relay?state=0
fi

    # threshold corresponds to remaining load of ≈1.5%
    # (assuming 0.3V/2 difference under load)
    # 20.5V/2 without load = 1.5% load remaining

if [ "$gridstate" == "true" ];
then
    if (( $(echo "$v1 < 10.5" |bc -l) )); then 
	actionlog "load on->off"
	curl -s http://${mystrom_gridinverter}/relay?state=0
    fi
fi

if [ "$chargerstate" == "false" ];
then
    if (( $(echo "$v1 < 10.4" |bc -l) )); then 
	actionlog "charger off->on"
	curl -s http://${mystrom_charger}/relay?state=1
    fi
fi

if [ "$chargerstate" == "true" ];
then
    if (( $(echo "$v1 > 11" |bc -l) )); then 
	actionlog "charger on->off"
	curl -s http://${mystrom_charger}/relay?state=0
    fi
fi


