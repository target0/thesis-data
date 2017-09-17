#!/bin/bash

source ./srdb-cli.sh

ovsdb_flush FlowReq
ovsdb_flush FlowState
ovsdb_flush LinkState
ovsdb_flush NodeState

add_node A fc00:2:0:1::1 fc00:2:0:1::/64 fc00:2:0:1::/64
add_node C fc00:2:0:2::1 fc00:2:0:2::/64 fc00:2:0:2::/64
add_node B fc00:2:0:3::1 fc00:2:0:3::/64 fc00:2:0:3::/64
add_node E fc00:2:0:4::1 fc00:2:0:4::/64 fc00:2:0:4::/64
add_node D fc00:2:0:5::1 fc00:2:0:5::/64 fc00:2:0:5::/64
add_node ctrl fc00:2:0:6::1 fc00:2:0:6::/64 fc00:2:0:6::/64
add_node F fc00:2:0:7::1 fc00:2:0:7::/64 fc00:2:0:7::/64
add_node server fc00:2:0:8::1 fc00:2:0:8::/64 fc00:2:0:8::/64
add_node client fc00:2:0:9::1 fc00:2:0:9::/64 fc00:2:0:9::/64

add_link client fc00:42:0:1::1 A fc00:42:0:1::2 1 100 100 1
add_link A fc00:42:0:2::1 B fc00:42:0:2::2 1 100 100 1
add_link B fc00:42:0:3::1 F fc00:42:0:3::2 1 100 100 1
add_link A fc00:42:0:4::1 C fc00:42:0:4::2 1 100 100 1
add_link C fc00:42:0:5::1 D fc00:42:0:5::2 1 100 100 1
add_link C fc00:42:0:6::1 E fc00:42:0:6::2 1 100 100 5
add_link D fc00:42:0:7::1 E fc00:42:0:7::2 1 100 100 1
add_link E fc00:42:0:8::1 F fc00:42:0:8::2 1 100 100 1
add_link C fc00:42:0:9::1 ctrl fc00:42:0:9::2 1 100 100 1
add_link F fc00:42:0:a::1 server fc00:42:0:a::2 1 100 100 1
