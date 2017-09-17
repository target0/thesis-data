#!/bin/bash

# CPUS="0 1 2 3 4 5 6 7"
CPUS="7"

DSTMAC="68:05:ca:0c:4c:b1" # comp5 enp1s0f1
SRCIP="fc00::44"
DSTIP="fc11::1"
DSTMIN="fc11::1"
DSTMAX="fc11::ffff:ffff:ffff:ffff"

# single flow setup
for cpu in $CPUS; do
        echo add_device enp1s0f1\@$cpu > /proc/net/pktgen/kpktgend_$cpu
        echo dst_mac $DSTMAC > /proc/net/pktgen/enp1s0f1\@$cpu
        echo src6 $SRCIP > /proc/net/pktgen/enp1s0f1\@$cpu
        echo dst6 $DSTIP > /proc/net/pktgen/enp1s0f1\@$cpu
        echo count 5000000 > /proc/net/pktgen/enp1s0f1\@$cpu
        echo pkt_size 78 > /proc/net/pktgen/enp1s0f1\@$cpu
        echo queue_map_max 7 > /proc/net/pktgen/enp1s0f1\@$cpu
        echo flag QUEUE_MAP_CPU > /proc/net/pktgen/enp1s0f1\@$cpu
	echo burst 10 > /proc/net/pktgen/enp1s0f1\@$cpu
done

# multi flow setup
for cpu in $CPUS; do
	echo add_device enp1s0f1\@$cpu > /proc/net/pktgen/kpktgend_$cpu
	echo dst_mac $DSTMAC > /proc/net/pktgen/enp1s0f1\@$cpu
	echo src6 $SRCIP > /proc/net/pktgen/enp1s0f1\@$cpu
	echo dst6 $DSTMIN > /proc/net/pktgen/enp1s0f1\@$cpu
	echo dst6_min $DSTMIN > /proc/net/pktgen/enp1s0f1\@$cpu
	echo dst6_max $DSTMAX > /proc/net/pktgen/enp1s0f1\@$cpu
	echo count 20000000 > /proc/net/pktgen/enp1s0f1\@$cpu
	echo pkt_size 78 > /proc/net/pktgen/enp1s0f1\@$cpu
	echo queue_map_max 7 > /proc/net/pktgen/enp1s0f1\@$cpu
	echo flag QUEUE_MAP_CPU > /proc/net/pktgen/enp1s0f1\@$cpu
	echo flag IPDST_RND > /proc/net/pktgen/enp1s0f1\@$cpu
	echo burst 10 > /proc/net/pktgen/enp1s0f1\@$cpu
done
