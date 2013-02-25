#/bin/bash

source nodes.sh
source common.sh

MASTER_LOG_FILE="working.log" 

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
        exit 1
fi

RHIVE_DATA=/tmp 


execute_cmd_on_nodes_n_collect_error_log "r_install" "yum install make -y" "prepare RPM packages to build R package on datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

execute_cmd_on_nodes_n_collect_error_log "r_install" "export "$"JAVA_HOME=$JAVA_HOME;R CMD javareconf" "run R CMD javareconf  to build R package on datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

cp ./data/rJava_0.9-3.tar.gz /tmp/
copy_data_to_nodes_n_collect_error_log "r_install" "/tmp/rJava_0.9-3.tar.gz" "/tmp/" "copy rJava Package to datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

cp ./data/Rserve_0.6-8.tar.gz /tmp/

copy_data_to_nodes_n_collect_error_log "r_install" "/tmp/Rserve_0.6-8.tar.gz" "/tmp/" "copy Rserve Package to datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

execute_cmd_on_nodes_n_collect_error_log "r_install" "R CMD INSTALL /tmp/rJava_0.9-3.tar.gz" "installing rJava on datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

execute_cmd_on_nodes_n_collect_error_log "r_install" "R CMD INSTALL /tmp/Rserve_0.6-8.tar.gz" "installing RServe on datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"


update_on_nodes_n_collect_error_log "r_install" "R CMD INSTALL /tmp/Rserve_0.6-8.tar.gz" "update /etc/profile on datanodes..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

copy_data_to_nodes_n_collect_error_log "r_install" "./data/Rserv.conf" "/etc/" "copy RServ.conf to datanodes /etc/..." "${ALLNODES[@]}" "$MASTER_LOG_FILE"

update_profile "${DATANODES[@]}"

