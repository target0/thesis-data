#!/usr/bin/env python

import sys, socket, os, time, uuid, threading, struct, signal
import select

cycles = []
stop = threading.Event()

class SRH:
	def __init__(self, segs):
		self.data = self.build_srh(segs)
		self.segs = segs

	def build_srh(self, segs):
		srh = ''
		nsegs = len(segs)
		srh += struct.pack("!BBBBBHB", 0, (nsegs+1)*2, 4, nsegs, nsegs, 0, 0)
		srh += '\x00'*16

		for seg in reversed(segs):
			srh += seg

		return srh

class Cycle:

	STATE_INIT = 0
	STATE_RTT1 = 1
	STATE_MON = 2
	STATE_SEND = 3
	STATE_RTT2 = 4
	STATE_DISAS = 5
	STATE_DWAIT = 6

	def __init__(self, id, size, segs, fullpath=None):
		self.id = id
		self.size = size
		self.segs = segs
		self.srh = SRH(segs)
		self.fullpath = fullpath
		self.lock = threading.Lock()

		self.T1 = 0.008

		tkn = uuid.uuid4()
		self.token = tkn.bytes
		self.xmt_id = 0
		self.xmt_time = 0		# T1
		self.rcv_time = 0		# T2
		self.xmt_disas_time = 0 # T3
		self.tmp_up = set()
		self.rtt = 0
		self.last_ack = 0
		self.state = Cycle.STATE_INIT
		self.rtt1_count = 10
		self.rtt1_thresh = self.rtt1_count

		self.disaspath = self.disassemble()

	def get_T1(self):
#		if self.rtt > 0:
#			return min(self.T1, 3*self.rtt)
		return self.T1

	def get_T2(self):
		return 2*self.get_T1()

	def get_T3(self):
		return 2*self.rtt

	def disassemble(self):
		if self.fullpath is not None:
			path = self.fullpath
		else:
			path = self.segs

		res = []

		for i in range(0, len(path)):
			res.append(path[:i+1])

		return res

def match_cycle(tkn):
	for c in cycles:
		if c.token == tkn:
			return c

	return None

class Receiver(threading.Thread):
	def __init__(self, ip, port):
		threading.Thread.__init__(self)
		self.ip = ip
		self.binip = socket.inet_pton(socket.AF_INET6, self.ip)
		self.port = port

	def run(self):
		sock = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
		sock.setblocking(0)
		sock.bind((self.ip, self.port))

		while not stop.is_set():
			datain, _, _ = select.select([sock], [], [], 10)
			if len(datain) == 0:
				continue

			data, addr = sock.recvfrom(1024)
			curt = time.time()
			raddr = socket.inet_pton(socket.AF_INET6, addr[0])
			rport = addr[1]

			if raddr != self.binip:
				print "Ignoring datagram from unknown source %s" % addr
				continue

			if len(data) < 18:
				print "Ignoring datagram with unknown length %d" % (len(data))
				continue

			tkn = data[:16]
			rcurt, disas, xmt, pid, = struct.unpack("!dBHB", data[16:])

			c = match_cycle(tkn)
			if c is None:
				print "Ignoring datagram matching unknown cycle"
				continue

			with c.lock:
				if disas == 1:
#				if c.state != Cycle.STATE_DWAIT:
#					print "Ignoring dprobe while not in DWAIT state for cycle %d" % c.id
#					continue

					c.tmp_up.add(pid)
					if len(c.tmp_up) == len(c.disaspath):
						print "All segments of cycle %d are up." % c.id
						c.tmp_up = set()
#						c.rcv_time = curt # avoid flooding
						c.rtt1_thresh = c.last_ack + c.rtt1_count
						c.state = Cycle.STATE_INIT
					continue

				if c.last_ack > xmt:
					print "Datagram is matching cycle %d but with outdated xmt_id (%d %d). Guess: high delay or reordering." % (c.id, xmt, c.xmt_id)
					continue

				if c.state == Cycle.STATE_RTT1:
					print "Cycle %d is UP ! D = %f ms. Resetting xmt_time." % (c.id, (curt - rcurt)*1000.0)
					if xmt > c.rtt1_thresh:
						c.state = Cycle.STATE_MON

#			if c.state != Cycle.STATE_MON:
#				print "Ignoring probe while not in MON state for cycle %d" % c.id
#				continue

				c.rcv_time = curt
				c.rtt = curt - rcurt
				c.last_ack = xmt

		sock.close()
		print 'Receiver exiting'

class Monitor(threading.Thread):
	def __init__(self):
		threading.Thread.__init__(self)

	def run(self):
		while not stop.is_set():
			for c in cycles:
				with c.lock:
					curt = time.time()
					if c.state == Cycle.STATE_RTT1:
						if curt - c.xmt_time >= c.get_T1():
							c.state = Cycle.STATE_SEND
					elif c.state == Cycle.STATE_MON:
						if curt - c.rcv_time >= c.get_T2():
							print "[%f] Cycle %d TIMEOUT (rtt = %f, delta = %f) ! Starting investigation." % (time.time(), c.id, c.rtt, curt - c.rcv_time)
							c.state = Cycle.STATE_DISAS
						elif curt - c.xmt_time >= c.get_T1():
							c.state = Cycle.STATE_SEND
					elif c.state == Cycle.STATE_DWAIT:
						if curt - c.xmt_disas_time >= c.get_T3():
							tmp = []
							for i in range(0, len(c.disaspath)):
								if i not in c.tmp_up:
									tmp.append(i)
							print "[%f] Disassembling for cycle %d TIMEOUT. Nearest down segment: %d" % (time.time(), c.id, min(tmp) if len(tmp) > 0 else -1)
							c.state = Cycle.STATE_DISAS

			time.sleep(0.001)
		print 'Monitor exiting'

class Transmitter(threading.Thread):
	def __init__(self, ip, port):
		threading.Thread.__init__(self)
		self.ip = ip
		self.port = port
		self.sock = None

	def send_probe(self, token, t, srh, xmt, disas=0, disasid=0):
		self.sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_RTHDR, srh.data)
		sdata = token + struct.pack("!dBHB", t, disas, xmt, disasid)
		self.sock.sendto(sdata, (self.ip, self.port))

	def run(self):
		self.sock = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
		self.sock.bind((self.ip, 0))

		while not stop.is_set():
			for c in cycles:
				with c.lock:
					curt = time.time()
					if c.state == Cycle.STATE_DISAS:
						dp = c.disaspath
						c.tmp_up = set()
						for i in range(0, len(dp)):
							p = dp[i]
							self.send_probe(c.token, curt, SRH(p), 0, disas=1, disasid=i)
						c.xmt_disas_time = curt
						c.state = Cycle.STATE_DWAIT
						continue

					if c.state == Cycle.STATE_INIT or c.state == Cycle.STATE_SEND:
						c.xmt_id += 1
						if c.xmt_id > 0xffff:
							c.xmt_id = 0
						self.send_probe(c.token, curt, c.srh, c.xmt_id)
						c.xmt_time = curt

						if c.state == Cycle.STATE_INIT:
							c.state = Cycle.STATE_RTT1
						else:
							if c.last_ack < c.rtt1_thresh:
								c.state = Cycle.STATE_RTT1
							else:
								c.state = Cycle.STATE_MON

			time.sleep(0.001)

		sock.close()
		print 'Transmitter exiting'

def handler(signum, frame):
	stop.set()

if __name__ == "__main__":

#	signal.signal(signal.SIGINT, handler)

	f = open(sys.argv[1], 'r')
	data = f.readlines()
	f.close()

	for line in data:
		line = line.strip()

		if len(line) == 0:
			continue

		if line[0] == '#':
			continue

		ldata = line.split(" ")

		cid = int(ldata[0])
		segs = ldata[1].split(",")
		csize = len(segs)
		fullpath = ldata[2].split(",")

		v6segs = []
		for s in segs:
			v6segs.append(socket.inet_pton(socket.AF_INET6, s))

		v6fpath = []
		for s in fullpath:
			v6fpath.append(socket.inet_pton(socket.AF_INET6, s))

		cycle = Cycle(cid, csize, v6segs, v6fpath)
		cycles.append(cycle)

	transm = Transmitter(sys.argv[2], int(sys.argv[3]))
	monit = Monitor()
	receiv = Receiver(sys.argv[2], int(sys.argv[3]))

	transm.daemon = True
	monit.daemon = True
	receiv.daemon = True

	try:
		receiv.start()
		monit.start()
		transm.start()
		while True: time.sleep(100)
	except (KeyboardInterrupt, SystemExit):
		stop.set()
		print 'exiting'

	print 'Main thread exiting'
