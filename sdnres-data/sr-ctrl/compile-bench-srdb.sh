#!/bin/bash

gcc -o bench-srdb bench-srdb.c -g -Wall -W -I.. -I../../lib -L../../lib -lsr -pthread -ljansson
