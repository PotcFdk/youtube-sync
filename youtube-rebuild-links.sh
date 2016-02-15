#!/bin/bash

mkdir -p SYNC/$1/LINK

if [ ! -d SYNC/$1/TITLE ]; then
	>&1 echo "Error: /TITLE directory doesn't exist for $1"
	exit
fi

rm SYNC/$1/LINK/*.mkv

for ID in SYNC/$1/TITLE/*; do
	read -r TITLE < $ID
	echo "Creating link: $ID -> $TITLE.mkv"
	ln -s "SYNC/$1/ID/$ID.mkv" "SYNC/$1/LINK/$TITLE.mkv"
done
