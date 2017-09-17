#!/bin/bash

j=1

for i in $(cat $1 | cut -d " " -f 6 | sort -n); do
	echo $i $j
	j=$(($j+1))
done
