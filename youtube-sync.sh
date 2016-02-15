#!/bin/bash
./youtube-dl -i -f bestvideo+bestaudio --merge-output-format mkv -o "SYNC/%(uploader)s/ID/%(id)s.mkv" $*
