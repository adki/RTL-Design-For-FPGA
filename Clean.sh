#!/bin/bash

for F in *; do
    if [[ -d "${F}" && ! -L "${F}" ]]; then
        if [ -f ${F}/codes/Clean.sh ]; then
	   echo ${F}/codes
           ( cd ${F}/codes; ./Clean.sh )
        fi
    fi
done
