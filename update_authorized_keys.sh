#!/bin/bash

usage() {
	echo "Usage: $0 [-d SSH_DIR] [-u KEYS_SOURCE_URL] [-t TAG]" >&2
	exit 1
}

ssh_dir="${HOME}/.ssh"
url="https://hackerspace.by/hackers/ssh_keys"
tag="hackerspace"

while getopts "d:u:" options; do
	case "${options}" in
		d)
			ssh_dir="${OPTARG}"
			;;
		u)
			url="${OPTARG}"
			;;
		t)
			tag="${OPTARG}"
			;;
		*)
			usage
			;;
	esac
done

tmpfile=`mktemp -q /tmp/sync-ssh-keys.XXXXXX`
if [ $? -ne 0 ]; then
        echo "$0: Can't create temp file, exiting..."
        exit 1
fi

trap "rm -f $tmpfile" EXIT

wget -q "$url" -O $tmpfile
if [ $? -ne 0 ]; then
        echo "$0: Can't download data"
        exit 1
fi

if [ ! -d "$ssh_dir/authorized_keys.d" ]; then
	mkdir -p "$ssh_dir/authorized_keys.d"
	chmod 700 "$ssh_dir/authorized_keys.d"
	cp -f "$ssh_dir/authorized_keys" "$ssh_dir/authorized_keys.d/authorized_keys.local"
fi

# Don't rewrite if keys were not updated
if ! diff -q "$ssh_dir/authorized_keys.d/authorized_keys.$tag" "$tmpfile"; then
	set -e
	cp "$tmpfile" "$ssh_dir/authorized_keys.d/authorized_keys.$tag"

	rm -f "$ssh_dir/.authorized_keys.new"
	for file in "$ssh_dir/authorized_keys.d/authorized_keys."*; do
		cat "$file" >> "$ssh_dir/.authorized_keys.new"
		echo -e "\n" >> "$ssh_dir/.authorized_keys.new"
	done

	mv "$ssh_dir/.authorized_keys.new" "$ssh_dir/authorized_keys"
	chmod 600 "$ssh_dir/authorized_keys"
fi

