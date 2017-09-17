#!/bin/bash

sysctl -w net.core.rmem_default=524287
sysctl -w net.core.wmem_default=524287
sysctl -w net.core.rmem_max=524287
sysctl -w net.core.wmem_max=524287
sysctl -w net.core.optmem_max=524287
sysctl -w net.core.netdev_max_backlog=300000
sysctl -w net.ipv4.tcp_rmem="10000000 10000000 10000000"
sysctl -w net.ipv4.tcp_wmem="10000000 10000000 10000000"
sysctl -w net.ipv4.tcp_mem="10000000 10000000 10000000"
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.ipv6.conf.all.seg6_enabled=1
sysctl net.ipv6.conf.enp1s0f1.seg6_enabled=1

ethtool -K enp1s0f1 gro off
ethtool -K enp1s0f1 gso off
ethtool -K enp1s0f1 tx off
ethtool -K enp1s0f1 rx off

# ixgbe trick to prevent unnecessary calls to ipv6_find_hdr()
# Improve perfs by ~1Mpps in rx-pause=off mode. No effect (currently)
# in rx-pause=on mode.
ethtool -K enp1s0f1 rx-ntuple-filter on

# Also improve perfs in rx-pause=off
ethtook -G enp1s0f1 tx 1024
ethtool -C enp1s0f1 rx-usecs 30

ip -6 ad ad fc00::44/64 dev enp1s0f1

for i in $(seq 38 45); do echo 7 > /proc/irq/$i/smp_affinity_list; done
