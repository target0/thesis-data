#!/bin/bash

j=1

for i in $(cat $1 | grep ^\\[ | cut -d " " -f 8 | cut -d "=" -f 2); do
	echo $j $i
	j=$(($j+1))
done
