#!/bin/bash

source ./srdb-cli.sh

ovsdb_flush FlowReq
ovsdb_flush FlowState
