#!/bin/bash
# remux.sh from youtube-sync
# remuxing mp4 files to mkv if needed

dlfile="$1"
remuxedfile="$1"

if [ -f "$dlfile" ]; then
    if [[  $dlfile == *".mkv" ]]; then
    	: #downloaded file is allready a mkv, nothing to do here.
    elif [[  $dlfile == *".mp4" ]]; then
    	#mp4 will be remuxed to mkv
    	if ffmpeg -i "SYNC/$1/ID/$ID.mp4" -map 0 -c copy -disposition:s:0 0 -c:s webvtt "SYNC/$1/ID/$ID.mkv" ; then
    	    if [ -f "$remuxedfile" ]; then
    	    	read -p "its converted check now"
    	    	#rm -rf $dlfile
    	    else
    	    	echo "Remuxed file $dlfile is missing. Something went wrong!"
    	    fi
    	else
    	    echo "Remux from $dlfile to MKV failed. Check ffmpeg log for details."
    	fi
    else
    	read -p "Downloaded file is neither a mkv or a mp4, something went wrong or its a webm. Check your ytdl-format syntax"
    fi
else
	echo "Downloaded file $dlfile not found. Something went wrong.";
fi