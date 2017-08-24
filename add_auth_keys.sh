#!/bin/bash

KEYS="${HOME}/.ssh/authorized_keys"

if [ -f ${KEYS}} ]; then
   echo "File ${KEYS} exists."
   echo cat ${KEYS}
else
   echo "File ${KEYS} does not exist... creating..."
   touch ${KEYS}
   chmod 600 ${KEYS}
fi

echo "add following files to ${KEYS}"

for f in *.pub; do
	echo "check key $f"
	KEY=`cat $f`
	
    if grep -Fxq "$KEY" ${KEYS}
	then
		echo "key $f already in authorized_keys"
	else
		echo "key $f not found, adding..."
		echo ${KEY} >> ${KEYS}
    fi

done
echo 'done'