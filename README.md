This repo contains scripts to sync SSH public keys at the server with hackerspace's users' profiles.
Add you public ssh keys to your profile at the hackerspace.by and run `update_authorized_keys.sh ` on the remote server.

Install requirements
===================

```
sudo apt-get install wget diffutils
```
or use other package manager to install wget && diff

Initial setup
=============

At the first run, the script will make the copy of existing `~/.ssh/authorized_keys` as `~/.ssh/authorized_keys.d/authorized_keys.local`.
Edit it if you need additional keys not synced with HS site or remove it otherwise.

The script will download file with keys of active HS users to `~/.ssh/authorized_keys.d/authorized_keys.hackerspace` and then merge local-specific and downloaded files to one `~/.ssh/authorized_keys`

How to update keys with one-liner
=================================

```
wget https://raw.githubusercontent.com/minsk-hackerspace/ssh-pub-keys/master/update_authorized_keys.sh -q -O - | sh
```
Short form:
```
wget goo.gl/jGyzbk -O - | sh
```

How to install an update as a cron job
======================================

Run this from command line under specific user
```
{ crontab -l; echo '*/10 * * * * wget https://raw.githubusercontent.com/minsk-hackerspace/ssh-pub-keys/master/update_authorized_keys.sh -q -O - | sh'; } | crontab -
```

This cron job will update keys every 10 minutes
