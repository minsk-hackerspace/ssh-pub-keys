ssh pub keys
============

This repo countains ssh public keys.
Add you public ssh keys *.pub into root folder 
And run add_auth_keys.sh on remote server


How to update keys with one-liner
=================================

```
wget https://raw.githubusercontent.com/minsk-hackerspace/ssh-pub-keys/master/update_authorized_keys.sh -O - | sh
```
Short form:
```
wget goo.gl/jGyzbk -O - | sh
```


How to install an update as a cron job
======================================

Run this from command line under specific user
```
{ crontab -l; echo '*/10 * * * * wget https://raw.githubusercontent.com/minsk-hackerspace/ssh-pub-keys/master/update_authorized_keys.sh -O - | sh'; } | crontab -
```

This cron job will update keys every 10 minutes

Beware, update script makes authorized_keys backup. It is your responsibility to delete old backups!

How to clean up old backups
===========================

```
find ~/.ssh -name "*authorized_keys_*" -mindepth 1 -mtime +5 -delete
find ~/.ssh/keys_backup -name "*authorized_keys_*" -mindepth 1 -mtime +5 -delete
```

Deletes backups older than 5 days
