#!/bin/bash

source common.sh
source nodes.sh

MASTER_LOG_FILE="working.log"

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
        exit 1
fi

kill_rserve "${DATANODES[@]}" $MASTER_LOG_FILE
start_rserve "${DATANODES[@]}" $MASTER_LOG_FILE

