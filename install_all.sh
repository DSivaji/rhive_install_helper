#/bin/bash

IAM=`whoami`
if [ "$IAM" != "root" ]; then
	echo "please run as root user"
	exit 1
fi


echo "this installer is for centOS 6.3 only , others are not tested"

if [ "$JAVA_HOME" ]; then
        echo "\$JAVA_HOME=$JAVA_HOME is set , please make sure \$JAVA_HOME is matched with \$JAVA_HOME in RHive users env."
else
        echo "\$JAVA_HOME is not set , please make sure \$JAVA_HOME is set."
        exit 1
fi

echo "if you want to see detail install log, run \"tail -f working.log\""
echo "press any key to continue....."
read push
./install_R.sh
./install_Rserve.sh
./install_RHive.sh
./start_Rserve.sh
./install_RStudio.sh

#./verify_all.sh
echo "please run verify_all_by_root.sh   as root and"
echo "run verify_all_by_user.sh   as ndap user"
