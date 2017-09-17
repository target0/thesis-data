#!/usr/bin/python2

import sys, numpy

for i in range(1, len(sys.argv)):
	f = open(sys.argv[i], 'r')
	data = f.readlines()
	f.close()

	msm = []

	for line in data:
		line = line.strip()
		msm.append(float(line)/1000.0)

	print "=== %s ===" % sys.argv[i]
	print 'Min: %f' % numpy.min(msm)
	print 'Max: %f' % numpy.max(msm)
	print 'Mean: %f' % numpy.mean(msm)
	print 'Median: %f' % numpy.median(msm)
	print 'Stddev: %f' % numpy.std(msm)
	print
