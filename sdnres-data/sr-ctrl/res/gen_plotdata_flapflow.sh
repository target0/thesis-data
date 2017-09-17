#!/bin/bash

j=1

for i in $(./extract_updatetime.py $1 | grep ^flow | cut -d " " -f 2 | sort -n); do
	echo $i $j
	j=$(($j+1))
done
