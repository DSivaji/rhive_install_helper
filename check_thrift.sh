source color.sh

CK_THRIFT=`netstat -nlp 2>/dev/null| grep 10000 | wc -l`

echo "checking hive-thrift service..."
if [ $CK_THRIFT == "1" ]; then
	echo "${txtgrn}OK${txtrst}"
else
	echo "${txtred}FAIL${txtrst}"
	exit 1
fi
	


