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
sysctl net.ipv6.conf.enp1s0f0.seg6_enabled=1
sysctl net.ipv6.conf.enp1s0f1.seg6_enabled=1

ethtool -K enp1s0f0 gro off
ethtool -K enp1s0f0 gso off
ethtool -K enp1s0f0 tx off
ethtool -K enp1s0f0 rx off

ethtool -K enp1s0f1 gro off
ethtool -K enp1s0f1 gso off
ethtool -K enp1s0f1 tx off
ethtool -K enp1s0f1 rx off

ethtool -K enp1s0f0 rx-ntuple-filter on
ethtool -K enp1s0f1 rx-ntuple-filter on

# RSS
for i in $(seq 0 7); do echo $i > /proc/irq/$(($i+29))/smp_affinity_list; done
for i in $(seq 0 7); do echo $i > /proc/irq/$(($i+38))/smp_affinity_list; done

# fake gateway
ip -6 neigh add fc01::abc lladdr 68:05:ca:13:53:00 dev enp1s0f0 nud permanent
ip -6 ro ad fc01::abc/128 dev enp1s0f0
