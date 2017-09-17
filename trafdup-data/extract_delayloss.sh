#!/bin/bash

for i in $(cat $1 | grep user | cut -d " " -f 3 | sed -e 's/elapsed//'); do m=$(echo $i | cut -d : -f 1); s=$(echo $i | cut -d : -f 2 | cut -d . -f 1); ms=$(echo $i | cut -d : -f 2 | cut -d . -f 2); echo "${m}*60*1000 + ${s}*1000 + ${ms}*10" | bc -ql; done | sort -n
