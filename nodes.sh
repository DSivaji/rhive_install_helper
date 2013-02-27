#/bin/bash

if [ "$DATANODES" ]; then
	echo "load hosts..."
else
	DATANODES=`cat $HADOOP_HOME/conf/slaves`


	if [ "$DATANODES" ]; then
		echo "read datanodes list from $HADOOP_HOME/conf"
	else
		DATANODES=`cat $HADOOP_CONF_DIR/slaves`

		if [ !"$DATANODES" ]; then
			echo "ERROR: make sure slaves file is on \$HADOOP or \$HADOOP_CONF_DIR"
			exit 1
		else
			echo "read datanodes list from $HADOOP_CONF_DIR/conf"
			exit 1
		fi
	fi


	ALLNODES="$DATANODES localhost"
fi

#check single mode localhost
if [ "${#DATANODES[@]}" = "1" ]; then

	ssh ${DATANODES[0]} 'touch ~/tmp_test_file_1232.txt' 
	CK_LOCAL=`ls ~/tmp_test_file_1232.txt 2>/dev/null| wc -l ` 

	if [ "$CK_LOCAL" == "1" ]; then
		echo "local install mode enabled."
		LOCAL_MODE=1		
		ALLNODES=$DATANODES
	fi

	ssh ${DATANODES[0]} 'rm ~/tmp_test_file_1232.txt &2>1' > /dev/null
fi


export DATANODES
export ALLNODES
export LOCAL_MODE
#echo "target nodes:"$ALLNODES

