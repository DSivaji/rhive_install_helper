#/bin/bash

source nodes.sh
source common.sh

echo "verify R component... at localhost "
Rscript -e "R.home(component='home')"

                if [ "$?" = "0" ]; then
                        echo "OK"
                else
                        echo "${txtred}FAILED${txtrst}"
                fi

verify_component "R" "Rscript -e \"R.home(component='home')\"" "verify R component..." "${DATANODES[@]}" "working.log"
