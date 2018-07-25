#!/bin/bash

type curl >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'cURL' installed, please install it to run the client. Visit https://curl.haxx.se/ to procced with your OS installer."; exit 1; }
type jq >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'jq' installed, please install it to run the client. Visit https://stedolan.github.io/jq/ to procced with your OS installer."; exit 1; }



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

main() {
    echo ""
    echo -e "${BOLD}backend-Test-V1 command line client :)(API version 1)${OFF}"
    echo ""
    while IFS=, 
    read numero1 operador numero2 
    do
        request
        echo "${numero1} ${operador} ${numero2} = $(cat res.json |jq '.resultado')" 
        echo "${numero1},${operador},${numero2},$(cat res.json |jq '.resultado')" >> registro.csv
    done < "sample.csv"
}
main
