#!/bin/bash
if [ -z "$1" ]; then
	>&2 echo "Missing sync directory name."
	exit 1
fi
if [ -z "$2" ]; then
	>&2 echo "Missing YouTube URL."
	exit 1
fi
./youtube-dl -i -f bestvideo+bestaudio --merge-output-format mkv -o "SYNC/$1/ID/%(id)s.mkv" $2
