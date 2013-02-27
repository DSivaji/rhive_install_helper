
if [ "$HADOOP_HOME" ]; then
        echo "\$HIVE_HOME=$HADOOP_HOME is set , please make sure \$HADOOP_HOME is matched with \$HADOOP_HOME in RHive users env."
else
        echo "\$HADOOP_HOME is not set , please make sure \$HADOOP_HOME is set."
        exit 1
fi


