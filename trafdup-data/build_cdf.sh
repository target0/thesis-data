#!/bin/bash

i=1; for data in $(cat $1 | sort -n); do echo $data $i; i=$(($i+1)); done
