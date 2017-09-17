#!/bin/bash

ev=${1}_event
pr=${1}_probe

cat ${ev}.dat | grep down > ${ev}_down.dat
cat ${pr}.dat | grep '^\[' | sed -e 's/\[//' | sed -e 's/\]//' > ${pr}_timeout.dat
python ../res/parse.py ${ev}_down.dat ${pr}_timeout.dat > ${1}_result.dat
cat ${1}_result.dat | grep cycle | grep -v ^# > ${1}_result_cycle.dat
j=1; for i in $(cat ${1}_result_cycle.dat | cut -d " " -f 3 | sort -n); do echo $i $j; j=$(($j+1)); done > ${1}_result_cycle_plot.dat

