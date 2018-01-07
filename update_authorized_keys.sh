#
# Run it as one-liner:
# wget https://raw.githubusercontent.com/minsk-hackerspace/ssh-pub-keys/master/update_authorized_keys.sh -O - | sh
# .. or just as usual from command line



# make temp folder
tempfoo=`basename $0`
TMPFILE=`mktemp -d -q /tmp/${tempfoo}.XXXXXX`
if [ $? -ne 0 ]; then
        echo "$0: Can't create temp file, exiting..."
        exit 1
fi

# download current keys zip
#curl -L https://github.com/minsk-hackerspace/ssh-pub-keys/archive/master.zip > ${TMPFILE}/master.zip
wget -q https://github.com/minsk-hackerspace/ssh-pub-keys/archive/master.zip -P ${TMPFILE}
if [ $? -ne 0 ]; then
        echo "$0: Can't download data"
        exit 1
fi

# obviously, unzip it
unzip -q -d ${TMPFILE} ${TMPFILE}/master.zip
if [ $? -ne 0 ]; then
        echo "$0: Can't unzip"
        exit 1
fi

# join keys to single file
cat ${TMPFILE}/ssh-pub-keys-master/*.pub > ${TMPFILE}/authorized_keys

#echo And the final authorized keys file is:
#cat ${TMPFILE}/authorized_keys

# make backup copy of authorized keys. suppress error messages
mkdir -p ~/.ssh/keys_backup
cp ~/.ssh/authorized_keys ~/.ssh/keys_backup/authorized_keys_$(date +"%Y%m%d_%H%M%S") 2>/dev/null || :

# Copy authorized_keys to its place
mkdir -p ~/.ssh
cp ${TMPFILE}/authorized_keys ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# clean shit up
rm -rf ${TMPFILE}
