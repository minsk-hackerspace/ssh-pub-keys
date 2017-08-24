
# make temp folder
tempfoo=`basename $0`
TMPFILE=`mktemp -d -q /tmp/${tempfoo}.XXXXXX`
if [ $? -ne 0 ]; then
        echo "$0: Can't create temp file, exiting..."
        exit 1
fi

# download current keys zip
#curl -L https://github.com/minsk-hackerspace/ssh-pub-keys/archive/master.zip > ${TMPFILE}/master.zip
wget https://github.com/minsk-hackerspace/ssh-pub-keys/archive/master.zip -P ${TMPFILE}

# obviously, unzip it
unzip -d ${TMPFILE} ${TMPFILE}/master.zip

# join keys to single file
cat ${TMPFILE}/ssh-pub-keys-master/*.pub > ${TMPFILE}/authorized_keys

echo And the final authorized keys file is:
cat ${TMPFILE}/authorized_keys

#chmod 600 ~/.ssh/authorized_keys

# clean shit up
rm -rf ${TMPFILE}
