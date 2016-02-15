#!/bin/bash
./youtube-dl -i -f bestvideo+bestaudio --merge-output-format mkv -o "SYNC/$1/ID/%(id)s.mkv" $2
