#!/bin/bash
if [ -z "$1" ]; then
	>&2 echo "Missing sync directory name."
	exit 1
fi

if [ -n "$2" ]; then
	URL="$2"
	mkdir -p SYNC/$1/META
	echo -n "$URL" > SYNC/$1/META/source
elif [ -f "SYNC/$1/META/source" ]; then
        read -r URL < "SYNC/$1/META/source"
else
	>&2 echo "Missing YouTube URL."
	exit 1
fi

./youtube-dl -i -f bestvideo+bestaudio --merge-output-format mkv -o "SYNC/$1/ID/%(id)s.mkv" "$URL"
