#!/bin/bash

DATADIR="/home/target0/ucl/fsa3d/thesis/phdthesis/data/comp4-data/pktgen"
OUTDIR=$1

for i in $DATADIR/*; do
	if [ -f "$i" ]; then
		cat $i | grep pps | cut -d " " -f 3 | sed -e 's/pps$//' | sort -n > $OUTDIR/$(basename $i)
	fi
done
