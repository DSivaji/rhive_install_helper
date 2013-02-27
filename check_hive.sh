if [ "$HIVE_HOME" ]; then
        echo "\$HIVE_HOME=$HIVE_HOME is set , please make sure \$HIVE_HOME is matched with \$HIVE_HOME in RHive users env."
else
        echo "\$HIVE_HOME is not set , please make sure \$HIVE_HOME is set."
        exit 1
fi



