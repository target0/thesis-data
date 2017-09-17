#!/bin/bash

ovsdb_client='/home/target0/openvswitch-2.6.1/ovsdb/ovsdb-client'
ovsdb_server='tcp:[::1]:6640'
ovsdb_database='SR_test'

function ovsdb_insert() {
        $ovsdb_client transact $ovsdb_server "[\"$ovsdb_database\", {\"op\": \"insert\", \"table\": \"$1\", \"row\": {$2}}]"
}

function ovsdb_update() {
	$ovsdb_client transact $ovsdb_server "[\"$ovsdb_database\", {\"op\": \"update\", \"table\": \"$1\", \"where\": [[\"_uuid\", \"==\", [\"uuid\", \"$2\"]]], \"row\": {$3}}]"
}

function ovsdb_delete() {
	$ovsdb_client transact $ovsdb_server "[\"$ovsdb_database\", {\"op\": \"delete\", \"table\": \"$1\", \"where\": [[\"_uuid\", \"==\", [\"uuid\", \"$2\"]]]}]"
}

function ovsdb_flush() {
	$ovsdb_client transact $ovsdb_server "[\"$ovsdb_database\", {\"op\": \"delete\", \"table\": \"$1\", \"where\": []}]"
}

function ovsdb_dump() {
	$ovsdb_client dump $ovsdb_server $ovsdb_database $1
}

function add_node() {
        ovsdb_insert NodeState '"name": "'$1'", "addr": "'$2'", "prefix": "'$3'", "pbsid": "'$4'"'
}

function add_link() {
        ovsdb_insert LinkState '"name1": "'$1'", "addr1": "'$2'", "name2": "'$3'", "addr2": "'$4'", "metric": '$5', "bw": '$6', "ava_bw": '$7', "delay": '$8
}

function add_flowreq() {
        ovsdb_insert FlowReq '"destination": "'$1'", "dstaddr": "'$2'", "source": "'$3'", "bandwidth": '$4', "delay": '$5', "router": "'$6'", "status": '$7
}
