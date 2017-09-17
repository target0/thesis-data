#!/bin/bash

gcc -o 01_buildseg 01_buildseg.c ../../graph.o ../../rules.o ../../sr-ctrl.o -g -Wall -W -O2 -I../.. -I../../../lib -L../../../lib -Wl,-wrap=main -lsr -pthread -ljansson
