#!/bin/bash

type curl >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'cURL' installed."; exit 1; }



request() {
    curl -s -X POST \
            http://localhost:3000//api/v1/operations \
            -H 'cache-control: no-cache' \
            -H 'content-type: application/json' \
            -d '{
                    "numero1":"'${numero1}'",
                    "operador": "'${operador}'",
                    "numero2": "'${numero2}'"}' > res.json
}

function readJson {  
  UNAMESTR=`uname`
  if [[ "$UNAMESTR" == 'Linux' ]]; then
    SED_EXTENDED='-r'
  elif [[ "$UNAMESTR" == 'Darwin' ]]; then
    SED_EXTENDED='-E'
  fi; 

  VALUE=`grep -m 1 "\"${2}\"" ${1} | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//'`

  if [ ! "$VALUE" ]; then
    echo "Error: Cannot find \"${2}\" in ${1}" >&2;
    exit 1
  else
    echo $VALUE
  fi; 
}

main() {
    echo ""
    echo -e "${BOLD}backend-Test-V1 command line client (API version 1)${OFF}"
    echo ""
    while IFS=, 
    read numero1 operador numero2 
    do
        request
        NAME=`readJson res.json resultado`
        echo "${numero1} ${operador} ${numero2} = $NAME" 
        echo "${numero1},${operador},${numero2},$NAME" >> registro.csv
    done < "sample.csv"
}
main
