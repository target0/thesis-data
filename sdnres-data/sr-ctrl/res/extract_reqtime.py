#!/usr/bin/python2

import sys

f = open(sys.argv[1], "r")
data = f.readlines()
f.close()

reqs = {}
resp = {}

for line in data:
	line = line.strip()
	ldata = line.split(' ')
	tstr = ldata[1]
	rid = int(ldata[3][1:])

	tsplit = tstr.split('.')
	tsplit[1] = ('0'*(6-len(tsplit[1]))) + tsplit[1]
	tmerge = '.'.join(tsplit)
	t = float(tmerge)

	if ldata[2] == 'REQ':
		reqs[rid] = t
	elif ldata[2] == 'RESPONSE':
		resp[rid] = t
	else:
		print 'what'

for reqid in sorted(reqs.keys()):
	print '%d %f' % (reqid, float((resp[reqid] - reqs[reqid]) * 1000.0))
