#!/bin/bash

perl scripts/extract-mp3-urls.pl "$@" | while read url; do
	if [ -e downloads/audio/`basename $url` ]; then
		continue
	fi
	echo $url
done | xargs wget --directory-prefix=downloads/audio
