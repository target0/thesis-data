#!/bin/bash

gcc -o bench-srdb-flap bench-srdb-flap.c -g -Wall -W -I.. -I../../lib -L../../lib -lsr -pthread -ljansson
