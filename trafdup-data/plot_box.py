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
		msmdata.append(float(line))

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

ax.set_xticklabels(map(lambda x: x['label'], msm), fontsize=18)
# ax.set_xlabel('Experiment', fontname="Helvetica", fontsize=18)
ax.set_xlabel('Loss percentage', fontsize=20)
ax.set_ylabel('Transaction time (milliseconds)', fontsize=20)
# ax.set_yticks(range(0, 1201, 100))
ax.set_yticklabels(map(str, range(0, 1601, 200)), fontsize=18)
ax.set_ylim([0, 1600])

fig.suptitle(sys.argv[1], fontsize=24)
fig.savefig(sys.argv[2])
