#!/usr/bin/env python

import sys

f = open(sys.argv[1], 'r')
event_data = f.readlines()
f.close()

f = open(sys.argv[2], 'r')
probe_data = f.readlines()
f.close()

i = 0

for ev in event_data:
	ev = ev.strip()
	evd = ev.split(' ')
	evtime = float(evd[0])
	edge = '=='.join(evd[1:3])
	dcycle = None

	while i < len(probe_data):
		pr = probe_data[i]
		pr = pr.strip()
		prd = pr.split(' ')
		prtime = float(prd[0])

		if prd[1] == 'Cycle' and prtime >= evtime:
			dcycle = int(prd[2])
			break
		i += 1

	if prtime - evtime >= 1.0:
		print '# Timeout cycle %s' % edge
		continue

	if i == len(probe_data):
		print '# End of probe data'
		break

	print 'cycle %s %f' % (edge, prtime - evtime)

	i += 1
	tmedge = False
	while i < len(probe_data):
		pr = probe_data[i]
		pr = pr.strip()
		prd = pr.split(' ')
		prtime = float(prd[0])

		if prtime - evtime >= 1.0:
			print '# Timeout edge %s' % edge
			tmedge = True
			break

		if prd[1] == 'Disassembling' and int(prd[4]) == dcycle:
			break
		i += 1

	if tmedge:
		continue

	if i == len(probe_data):
		print '# End of probe data'
		break

	print 'edge %s %f' % (edge, prtime - evtime)
