#!/bin/bash

source common.sh
source nodes.sh

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
        exit 1
fi


kill_rserve "${DATANODES[@]}" "working.log"

