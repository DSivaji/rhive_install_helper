#/bin/bash

source nodes.sh
source common.sh
source version.sh

RN_ck_VER="/tmp/"$RN"tmp".log
RN_ck_PORT="/tmp/"$RN"port".log

echo "checking Rservers(version $Rserve_version) on datanodes..."
#verify_component "R" "Rscript -e \"R.home(component='home')\"" "verify R component..." "${ALLNODES[@]}" "working.log"

for line in $DATANODES
do
        #echo "check Rserve deamon on "$line
        ssh $line "netstat -nltp | grep '/Rserve' | awk '{print \$4}' | cut -d ':' -f 2" > $RN_ck_PORT
        RSERVE_PORT=`cat $RN_ck_PORT`
        ssh $line "Rscript -e 'library(Rserve);sessionInfo();'| grep Rserve" > $RN_ck_VER
        RSERVE_VER=`cat $RN_ck_VER`

        if [ "$RSERVE_PORT" = "6311" ]; then
              echo "deamon is running - SUCCESS"
        else
              echo "deamon is not running - FAILED"
        fi


        if [ "$RSERVE_VER" == "$Rserve_version" ]; then
              echo ""
        else
              echo "Rserve_version is not matched - FAILED"
        fi  


done

