#/bin/bash

source nodes.sh
source common.sh
source color.sh

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
        exit 1
fi

LOG_FILE="working_install_R.log"
MASTER_LOG_FILE="working.log"

echo "installing epel for R install ...."

rpm -Uvh ./data/epel-release-6-8.noarch.rpm 2>&1 > $LOG_FILE



#install local R
#execute_cmd_on_nodes_n_collect_error_log "r_install" "yum install R -y" "installing R on datanodes..." "${ALLNODES[@]}" "$LOG_FILE"
execute_parallel_cmd_on_nodes_n_collect_error_log "r_install" "yum install R -y" "installing R on datanodes..." "${ALLNODES[@]}" "$LOG_FILE"

 

#merge log to master log
cat $LOG_FILE > $MASTER_LOG_FILE
