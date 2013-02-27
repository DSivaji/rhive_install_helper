CK_THRIFT=`netstat -nlp 2>/dev/null| grep 10000 | wc -l`

echo "checking hive-thrift service..."
if [ $CK_THRIFT == "1" ]; then
	echo "OK"
else
	echo "FAIL"
	exit 1
fi
	


