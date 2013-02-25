#/bin/bash

source nodes.sh
source common.sh

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
        exit 1
fi

#install local R
execute_cmd_on_nodes_n_collect_error_log "r_install" "yum install R -y" "installing R on datanodes..." "${ALLNODES[@]}" "working.log"

