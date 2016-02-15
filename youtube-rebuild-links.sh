#!/bin/bash

if [ -z "$1" ]; then
	>&2 echo "Missing sync directory name."
	exit 1
fi

mkdir -p SYNC/$1/LINK

if [ ! -d SYNC/$1/TITLE ]; then
	>&1 echo "Error: /TITLE directory doesn't exist for $1"
	exit 1
fi

rm SYNC/$1/LINK/*.mkv

for ID in SYNC/$1/TITLE/*; do
	read -r TITLE < $ID
	echo "Creating link: $ID -> $TITLE.mkv"
	ln -s "SYNC/$1/ID/$ID.mkv" "SYNC/$1/LINK/$TITLE.mkv"
done
