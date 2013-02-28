#source nodes.sh
#source common.sh
source env.sh
source color.sh
source version.sh


./check_thrift.sh
if [ $? == "1" ]; then
        exit 1
fi

./check_hadoop.sh
if [ $? == "1" ]; then
        exit 1
fi

./check_hive.sh
if [ $? == "1" ]; then
        exit 1
fi


THRIFT_ADDRESS="host="$RHIVE_HIVE_THRIFT_ADDRESS",port="$RHIVE_HIVE_THRIFT_PORT

RN_ck_FILE=$RN"tmp".log
echo " "
echo "checking RHive Hive integration - UDF functions ..."

Rscript -e 'tmp_table_name<-sample(1:1000000, 1);tmp_table_name<-paste("tmp_",tmp_table_name,sep="");library(RHive);rhive.connect('$THRIFT_ADDRESS');rhive.write.table(tablename=tmp_table_name,USArrests);sumCrimes <- function(column1, column2, column3) {return(1)};rhive.assign("sumCrimes", sumCrimes);rhive.export("sumCrimes");rhive.query(paste("SELECT sum(R(\"sumCrimes\", murder, assault, rape, 0.0)) FROM ",tmp_table_name, " limit 1",sep=""));rhive.drop.table(tmp_table_name)'  > $RN_ck_FILE 2> /dev/null

        RES2=`cat $RN_ck_FILE | tail -n 1 | cut -d ' ' -f 4`

	#echo "return for UDF "$RES2

        if [ "$RES2" == "50" ]; then
              echo -e "RHive UDF function is working - OK}"
        else
		tput setaf 1
              echo -e "RHive UDF is not working - FAILED"
		tput sgr0
        fi

        rm $RN_ck_FILE


echo "checking RHive Hive integration - Normal Query ..."
Rscript -e "tmp_table_name<-sample(1:1000000, 1);tmp_table_name<-paste('tmp_',tmp_table_name,sep='');library(RHive);rhive.connect("$THRIFT_ADDRESS");rhive.write.table(tablename=tmp_table_name,USArrests);tmp <- rhive.size.table(tmp_table_name);cat(tmp);rhive.drop.table(tmp_table_name);" 2> /dev/null | tail -n 1 > $RN_ck_FILE
	
        RES2=`cat $RN_ck_FILE`

        if [ "$RES2" == "1247" ]; then
              echo -e "RHive hive Query function is working - ${txtgrn}OK${txtrst}"
        else
		tput setaf 1
              echo -e "RHive Query is not working - ${txtred}FAILED${txtrst}"
		tput sgr0
        fi  

	rm $RN_ck_FILE



