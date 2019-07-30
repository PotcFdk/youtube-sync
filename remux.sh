#!/bin/bash
# remux.sh from youtube-sync
# remuxing mp4 files to mkv if needed

dlfile="$1"
remuxedfile="${dlfile/.mp4/.mkv}"

if [ -f "$dlfile" ]; then
    if [[  $dlfile == *".mkv" ]]; then
    	echo "[remux] Downloaded file is allready an mkv, no remux needed."
    elif [[  $dlfile == *".mp4" ]]; then
    	echo -e "[remux] Start to remux $dlfile to $remuxedfile.\nIf you see this message too often, you should maybe change the syntax of your ytdl-format in the [META/format] file to avoid unnecessary IO.\nCheckout https://github.com/ytdl-org/youtube-dl/blob/master/README.md#format-selection"
    	if ffmpeg -loglevel warning -hide_banner -i "$dlfile" -map 0 -c copy -disposition:s:0 0 -c:s webvtt "$remuxedfile" ; then
    	    if [ -f "$remuxedfile" ]; then
    	    	rm -rf $dlfile
                echo "[remux] Remux successfull"
    	    else
    	    	echo "[remux] Remuxed file $dlfile is missing. Something went wrong!"
                exit 1
    	    fi
    	else
    	    echo "[remux] Remux from $dlfile to $remuxedfile failed. Check ffmpeg log for details."
            exit 1
    	fi
    else
    	read -p "[remux] Downloaded file is neither a mkv nor a mp4, something went wrong or its a webm. Check your ytdl-format syntax."
        exit 1
    fi
else
	echo "[remux] Downloaded file $dlfile not found. Something went wrong.";
    exit 1
fi