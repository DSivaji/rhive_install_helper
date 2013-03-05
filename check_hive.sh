source color.sh

if [ "$HIVE_HOME" ]; then
        echo "\$HIVE_HOME=$HIVE_HOME is set , please make sure \$HIVE_HOME is matched with \$HIVE_HOME in RHive users env."
else
        echo "\$HIVE_HOME is not set , please make sure \$HIVE_HOME is set."
        exit 1
fi


export HIVE_VERSION=`ls $HIVE_HOME/lib/hive-common* | cut -d '-' -f 3`

echo "hive version "${txtgrn}$HIVE_VERSION${txtrst}" is detected."
		
