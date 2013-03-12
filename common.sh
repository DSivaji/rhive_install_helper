source color.sh

RN=$RANDOM

#install local R
verify_component()
{
#r_install
   TARGET_DATA=$1
#yum install R -y
   EXECUTE_CMD=$2
#installing R on..
   MSG=$3
#slave1 slave2
   NODES=$4

        MASTER_LOCAL_LOG_FILE=$5

        NODE_WORK_LOG_FILE="/tmp/"$TARGET_DATA""$RN".log"

#       echo "echo on execute_cmd_on_nodes_n:"$TARGET_DATA" "$EXECUTE_CMD" "$MSG" "$NODES" "$NODE_WORK_LOG_FILE" "$MASTER_LOCAL_LOG_FILE
#       echo "echo on execute_cmd_on_nodes_n:"$1" "$2" "$3" "$4" "$5
        OK_FLAG=1

        for line in $NODES
        do
                echo $MSG" at "$line
                ssh $line $EXECUTE_CMD "2>&1;echo $? >"$NODE_WORK_LOG_FILE >>"$MASTER_LOCAL_LOG_FILE"
                RES=`ssh $line "cat "$NODE_WORK_LOG_FILE`
                if [ "$RES" = "0" ]; then
                        echo "${txtgrn}OK${txtrst}"
                else
                        echo "${txtred}FAILED${txtrst}"
                        OK_FLAG=0
                fi
        done

        if [ "$OK_FLAG" = "1" ]; then
              echo "${txtgrn}All components are OK${txtrst}"
        else
              echo "${txtred}some components varification Failed${txtrst}"
              OK_FLAG=0
        fi
}


#only used for yum
execute_parallel_cmd_on_nodes_n_collect_error_log()
{
#r_install
        TARGET_DATA=$1
#yum install R -y
   EXECUTE_CMD=$2
#installing R on..
   MSG=$3
#slave1 slave2
   NODES=$4

        MASTER_LOCAL_LOG_FILE=$5

        NODE_WORK_LOG_FILE="/tmp/"$TARGET_DATA""$RN".log"

        #echo "echo on execute_cmd_on_nodes_n:"$TARGET_DATA" "$EXECUTE_CMD" "$MSG" "$NODES" "$NODE_WORK_LOG_FILE" "$MASTER_LOCAL_LOG_FILE
        #echo "echo on execute_cmd_on_nodes_n:"$1" "$2" "$3" "$4" "$5

        for line in $NODES
        do
                echo $MSG" "$line
                echo $MSG" "$line>>"$MASTER_LOCAL_LOG_FILE"
                ssh -f $line "$EXECUTE_CMD 2>&1" >> $NODE_WORK_LOG_FILE"_"$line #>>"$MASTER_LOCAL_LOG_FILE"
#ssh $line "R CMD Rserve --no-save;ps -ef | grep Rserv "
        done

while true
do
        CK=0;
        for line in $NODES
        do
                RES=`tail -n 20 $NODE_WORK_LOG_FILE"_"$line | grep "already installed"`
                RES2=`tail -n 20 $NODE_WORK_LOG_FILE"_"$line | grep "Complete"`
                if [[ $RES || $RES2 ]]; then
                        echo "$line : ${txtgrn}SUCCESS${txtrst}"
                else
                        CK=1;
                        echo -n "$line : "
                        tail -n 1 $NODE_WORK_LOG_FILE"_"$line
                fi
        done
                if [ "$CK" = "0" ]; then
                        break;
                fi
        sleep 2
        clear
done

        echo "all done.!"

}

execute_cmd_on_nodes_n_collect_error_log()
{
#r_install
	TARGET_DATA=$1
#yum install R -y
   EXECUTE_CMD=$2
#installing R on..
   MSG=$3
#slave1 slave2
   NODES=$4

	MASTER_LOCAL_LOG_FILE=$5

	NODE_WORK_LOG_FILE="/tmp/"$TARGET_DATA""$RN".log"

	#echo "echo on execute_cmd_on_nodes_n:"$TARGET_DATA" "$EXECUTE_CMD" "$MSG" "$NODES" "$NODE_WORK_LOG_FILE" "$MASTER_LOCAL_LOG_FILE
	#echo "echo on execute_cmd_on_nodes_n:"$1" "$2" "$3" "$4" "$5

	for line in $NODES
	do
		echo $MSG" "$line
		echo $MSG" "$line>>"$MASTER_LOCAL_LOG_FILE"
		ssh $line "$EXECUTE_CMD" "2>&1;echo $? >"$NODE_WORK_LOG_FILE >>"$MASTER_LOCAL_LOG_FILE"
		RES=`ssh $line "cat "$NODE_WORK_LOG_FILE`
		if [ "$RES" = "0" ]; then
			echo "${txtgrn}SUCCESS${txtrst}"
		else
			echo "${txtred}FAILED${txtrst}"
		fi
#ssh $line "R CMD Rserve --no-save;ps -ef | grep Rserv "
	done
}

copy_data_to_nodes_n_collect_error_log()
{
   TARGET_DATA=$1
   TARGET=$2
   DEST=$3
   MSG=$4
   NODES=$5
	MASTER_LOCAL_LOG_FILE=$6

#   echo "testZ"$TARGET_DATA" "$TARGET" "$DESG" "$MSG" "$NODES" "$MASTER_LOCAL_LOG_FILE
#   echo "testZ"$1" "$2" "$3" "$4" "$5" "$6

   for line in $NODES
   do
      echo $MSG" "$line
      echo $MSG" "$line >> "$MASTER_LOCAL_LOG_FILE"
      scp $TARGET $line:$DEST 2>>$MASTER_LOCAL_LOG_FILE  1>> "$MASTER_LOCAL_LOG_FILE"
		RES=$?
      if [ "$RES" = "0" ]; then
	 echo "${txtgrn}SUCCESS${txtrst}"
      else
	 echo "${txtred}FAILED${txtrst}"
      fi
#ssh $line "R CMD Rserve --no-save;ps -ef | grep Rserv "
   done
}


start_rserve()
{
MASTER_LOCAL_LOG_FILE=$2
for line in $1
do
	echo "start Rserve deamon on "$line
	ssh $line -f -n "R CMD Rserve --vanilla 2>&1" >> $MASTER_LOCAL_LOG_FILE
done
}


kill_rserve()
{
MASTER_LOCAL_LOG_FILE=$2
for line in $1
do
	echo "shut down Rserve deamon on "$line
	ssh $line 'kill `ps -ef | grep "/bin/Rserve --vanilla" | grep -v grep | awk '\''{print $2}'\''` 2>&1' >> $MASTER_LOCAL_LOG_FILE
done
} 

start_rserve_debug()
{
MASTER_LOCAL_LOG_FILE=$2
for line in $1
do
        echo "start Rserve deamon on "$line
        ssh $line -f -n "R CMD Rserve --vanilla 2>&1 > /var/log/Rserve.log" >> $MASTER_LOCAL_LOG_FILE
done
}


update_profile()
{
for line in $1
do
	echo "set  /usr/lib64/R/etc/Renviron on "$line
	echo "this tool will not update any change future, if you change directory  you shold do it manualy then restart Rservs on datanods"$line
	CK=`ssh $line "cat  /usr/lib64/R/etc/Renviron |grep RHIVE_DATA"`
	if [ -z "$CK" ]; then
        	ssh $line "cat >> /usr/lib64/R/etc/Renviron" < ./rhive_data.sh
	else
		echo "no change , already set at "
		ssh $line "cat  /usr/lib64/R/etc/Renviron |grep RHIVE_DATA"
	fi
done
}


check_root()
{

#check pre requirement
IAM=`whoami`
if [ "$IAM" != "root" ]; then
        echo "${txtred}please run as root user${txtrst}"
        exit 1
fi
	exit 0
}
