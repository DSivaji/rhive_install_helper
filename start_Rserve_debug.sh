#!/bin/bash

source common.sh
source nodes.sh

MASTER_LOG_FILE="working.log"

kill_rserve "${DATANODES[@]}" $MASTER_LOG_FILE
start_rserve_debug "${DATANODES[@]}" $MASTER_LOG_FILE

