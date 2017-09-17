#!/bin/bash

j=1

for i in $(cat $1 | grep ^\\[ | cut -d " " -f 8 | cut -d "=" -f 2 | sort -n); do
	echo $i $j
	j=$(($j+1))
done
