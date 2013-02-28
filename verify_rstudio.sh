source color.sh

mkdir -p tmp
cd tmp

rm -f *.ht*
wget http://localhost:8787 -q

echo "verify rstudio component..."
CK=`ls *.ht*| wc -l`
rm -f *.ht*
if [ "$CK" = "1" ]; then
      echo "${txtgrn}SUCCESS${txtrst}"
else
      echo "${txtred}FAILED${txtrst}"
fi


