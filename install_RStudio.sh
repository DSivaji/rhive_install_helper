#/bin/bash
source color.sh

LOG_FILE="working_RStudio.log"
MASTER_LOG_FILE="working_RStudio.log"
echo " " >  $LOG_FILE
echo "installing compat-libgfortran-41 ...."
yum install compat-libgfortran-41 -y 2>> $MASTER_LOG_FILE >> $MASTER_LOG_FILE


echo "installing openssl098e ...."
yum install openssl098e -y  2>> $MASTER_LOG_FILE >> $MASTER_LOG_FILE



echo "installing rstudio-server ...."
rpm -Uvh ./data/rstudio-server-0.97.318-x86_64.rpm 2>> $MASTER_LOG_FILE >> $MASTER_LOG_FILE

cat $LOG_FILE >> $MASTER_LOG_FILE
