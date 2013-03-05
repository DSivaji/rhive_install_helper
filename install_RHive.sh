#/bin/bash

source common.sh
source nodes.sh 
source check_hive.sh

MASTER_LOG_FILE="working.log"

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "please run as root user"
#        exit 1
fi


#R CMD INSTALL ./data/RHive_0.0-7.tar.gz 2>> $MASTER_LOG_FILE >> $MASTER_LOG_FILE

cd ./data/RHive

if [ $HIVE_VERSION == "0.10.0" ]; then
	ant main-hive10			
else
	ant			
fi

cd build/CRAN
R CMD INSTALL rhive
