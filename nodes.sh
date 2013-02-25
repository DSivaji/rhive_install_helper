#/bin/bash



if [ "$DATANODES" ]; then
	echo "load hosts..."
else
	DATANODES=`cat $HADOOP_HOME/conf/slaves`


	if [ "$DATANODES" ]; then
		echo "read datanodes list from $HADOOP_HOME/conf"
	else
		DATANODES=`cat $HADOOP_CONF_DIR/conf/slaves`

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

export DATANODES
export ALLNODES
#echo "target nodes:"$ALLNODES
