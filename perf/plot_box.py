#!/usr/bin/python2

import sys
import matplotlib.pyplot as plt
from matplotlib import rc

msm = []

for i in range(3, len(sys.argv)):
	fdata = sys.argv[i].split(':')
	fname = fdata[0]
	label = fdata[1]
	msmdata = []

	f = open(fname, 'r')
	data = f.readlines()
	f.close()

	for line in data:
		line = line.strip()
		msmdata.append(float(line)/1000.0)

	msm.append({'label': label, 'data': msmdata})

rc('text', usetex=True)
plt.rcParams['text.latex.preamble'] = [
	r'\usepackage{tgheros}',
	r'\usepackage{sansmath}',
	r'\sansmath',
	r'\usepackage{siunitx}',
	r'\sisetup{detect-all}',
]

plt.hold(True)
fig = plt.figure()
ax = fig.add_subplot(111)
bp = ax.boxplot(map(lambda x: x['data'], msm), whis=[5,95])

ax.set_xticklabels(map(lambda x: x['label'], msm), fontsize=12)
# ax.set_xlabel('Experiment', fontname="Helvetica", fontsize=18)
ax.set_ylabel('Throughput (Kpps)', fontsize=16)
# ax.set_yticks(range(0, 1201, 100))
# ax.set_yticklabels(map(str, range(0, 1201, 100)), fontname="Arial", fontsize=12)
ax.set_ylim([200, 1200])

fig.suptitle(sys.argv[1], fontsize=16)
fig.savefig(sys.argv[2])
