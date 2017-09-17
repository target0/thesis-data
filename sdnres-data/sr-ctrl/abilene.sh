#!/bin/bash

source ./srdb-cli.sh

ovsdb_flush FlowReq
ovsdb_flush FlowState
ovsdb_flush LinkState
ovsdb_flush NodeState

add_node STTL fc00:1::1 fc00:1::/64 fc00:1::/64
add_node SNVA fc00:2::1 fc00:2::/64 fc00:2::/64
add_node LOSA fc00:3::1 fc00:3::/64 fc00:3::/64
add_node DENV fc00:4::1 fc00:4::/64 fc00:4::/64
add_node KSCY fc00:5::1 fc00:5::/64 fc00:5::/64
add_node HSTN fc00:6::1 fc00:6::/64 fc00:6::/64
add_node CHIN fc00:7::1 fc00:7::/64 fc00:7::/64
add_node IPLS fc00:8::1 fc00:8::/64 fc00:8::/64
add_node ATLA fc00:9::1 fc00:9::/64 fc00:9::/64
add_node WASH fc00:10::1 fc00:10::/64 fc00:10::/64
add_node NYCM fc00:11::1 fc00:11::/64 fc00:11::/64

add_link STTL fc42:1::1 SNVA fc42:1::2 1 100 100 1
add_link STTL fc42:2::1 DENV fc42:2::2 1 100 100 1
add_link SNVA fc42:3::1 DENV fc42:3::2 1 100 100 1
add_link DENV fc42:4::1 KSCY fc42:4::2 1 100 100 1
add_link SNVA fc42:5::1 KSCY fc42:5::2 1 100 100 1
add_link SNVA fc42:6::1 LOSA fc42:6::2 1 100 100 1
add_link LOSA fc42:7::1 HSTN fc42:7::2 1 100 100 1
add_link HSTN fc42:8::1 KSCY fc42:8::2 1 100 100 1
add_link KSCY fc42:9::1 IPLS fc42:9::2 1 100 100 1
add_link IPLS fc42:10::1 ATLA fc42:10::2 1 100 100 1
add_link HSTN fc42:11::1 ATLA fc42:11::2 1 100 100 1
add_link IPLS fc42:12::1 CHIN fc42:12::2 1 100 100 1
add_link CHIN fc42:13::1 NYCM fc42:13::2 1 100 100 1
add_link NYCM fc42:14::1 WASH fc42:14::2 1 100 100 1
add_link WASH fc42:15::1 ATLA fc42:15::2 1 100 100 1
