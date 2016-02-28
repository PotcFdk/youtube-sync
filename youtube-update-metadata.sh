#!/bin/bash

if [ -z "$1" ]; then
	>&2 echo "Missing sync directory name."
	exit 1
else
    name="$1"
fi

domissing=0
if [ x"$2" = "x--missing-only" ]; then
	echo "Only fetching missing metadata"
	domissing=1
fi

mkdir -p SYNC/$name/META

num_total=$(find "SYNC/$name/ID/" -maxdepth 1 -name "*.mkv" | wc -l)
num_current=1

for filen in SYNC/$name/ID/*.mkv; do
	if [ -f "$filen" ]; then
		if [[ "$filen" =~ /([^/]+)\.mkv$ ]]; then
			ID=${BASH_REMATCH[1]};
			titlefile=SYNC/$name/META/$ID.title
			descfile=SYNC/$name/META/$ID.description
			if [ $domissing -eq 1 \
					-a -f $titlefile -a -f $descfile ]; then
				echo "Skipping known meta for $ID"
				num_current=$((num_current+1))
				continue
			fi
			echo -n "Updating metadata ($num_current/$num_total): $ID...";
			TITLE=$(youtube-dl --get-filename -o '%(title)s' -- "$ID");
			if [ -z "$TITLE" ]; then
				echo " [Error] Video might be down. We'll keep the old link."
			else
				echo " [OK]"
				echo -n "$TITLE" > $titlefile
				DESCRIPTION=$(youtube-dl --get-description -- "$ID");
				if [ -n "$DESCRIPTION" ]; then
					echo "$DESCRIPTION" > $descfile
				fi
			fi
		fi
	fi
	num_current=$((num_current+1))
done
