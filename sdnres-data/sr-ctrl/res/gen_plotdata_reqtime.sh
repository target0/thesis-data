#!/bin/bash

j=1

for i in $(./extract_reqtime.py $1 | cut -d " " -f 2 | sort -n); do
	echo $i $j
	j=$(($j+1))
done
