#!/bin/bash

FILES=SYNC/$1/ID/*.mkv

mkdir -p SYNC/$1/TITLE

for filen in $FILES; do
	if [ -f "$filen" ]; then
		if [[ "$filen" =~ /([^/]+)\.mkv$ ]]; then
			ID=${BASH_REMATCH[1]};
			echo "Checking video title for $ID...";
			TITLE=$(./youtube-dl --get-filename -o '%(title)s' "$ID");
			if [ -z "$TITLE" ]; then
				echo "Error. Video might be down. We'll keep the old link."
			else
				echo "New video title: $TITLE";
				echo -n $TITLE > SYNC/$1/TITLE/$ID
			fi
		fi
	fi
done
