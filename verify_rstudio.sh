cd tmp

rm -f *.ht*
wget http://localhost:8787 -q

echo "verify rstudio component..."
CK=`ls *.ht*| wc -l`
rm -f *.ht*
if [ "$CK" = "1" ]; then
      echo "SUCCESS"
else
      echo "FAILED"
fi


