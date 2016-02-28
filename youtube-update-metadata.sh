#!/bin/bash

if [ -z "$1" ]; then
	>&2 echo "Missing sync directory name."
	exit 1
fi

mkdir -p SYNC/$1/META

num_total=$(find "SYNC/$1/ID/" -maxdepth 1 -name "*.mkv" | wc -l)
num_current=1

for filen in SYNC/$1/ID/*.mkv; do
	if [ -f "$filen" ]; then
		if [[ "$filen" =~ /([^/]+)\.mkv$ ]]; then
			ID=${BASH_REMATCH[1]};
			echo -n "Updating metadata ($num_current/$num_total): $ID...";
			TITLE=$(youtube-dl --get-filename -o '%(title)s' -- "$ID");
			if [ -z "$TITLE" ]; then
				echo " [Error] Video might be down. We'll keep the old link."
			else
				echo " [OK]"
				echo -n "$TITLE" > SYNC/$1/META/$ID.title
				DESCRIPTION=$(youtube-dl --get-description -- "$ID");
				if [ -n "$DESCRIPTION" ]; then
					echo "$DESCRIPTION" > SYNC/$1/META/$ID.description
				fi
			fi
		fi
	fi
	num_current=$((num_current+1))
done
