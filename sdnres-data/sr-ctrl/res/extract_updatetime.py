#!/usr/bin/python2

import sys

f = open(sys.argv[1], "r")
data = f.readlines()
f.close()

STATE_FLAPPED = 1
STATE_FIRST = 2
STATE_OTHERS = 3

curstate = 0
prev_t = None

for line in data:
	line = line.strip()
	ldata = line.split(' ')
	t = float(ldata[1])

	if ldata[2] == 'FLAP_DOWN':
		curstate = STATE_FLAPPED
	elif ldata[2] == 'UPDATE':
		if curstate == STATE_FLAPPED:
			curstate = STATE_FIRST
		elif curstate == STATE_FIRST:
			curstate = STATE_OTHERS
		elif curstate == STATE_OTHERS:
			pass
		else:
			print 'wut'
	elif ldata[2] == 'FLAP_UP':
		curstate = 0

	if curstate == STATE_FIRST:
		print 'sweep %f' % (float(t - prev_t) * 1000.0)
	elif curstate == STATE_OTHERS:
		print 'flow %f' % (float(t - prev_t) * 1000.0)

	prev_t = t
