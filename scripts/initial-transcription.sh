#!/bin/bash

: ${AUDIO_CORPUS_DIR:=downloads/audio}

find "$AUDIO_CORPUS_DIR/" -name '*.mp3' | while read inaudiofn; do
    stem=`basename "$inaudiofn" | sed "s/\.[^.]\+$//"`
    tempdir="$REC_WORKDIR/$stem"
    mkdir "$tempdir" || continue
    outfn="$RECOUTDIR/$stem.recout"
    echo "-> $stem " >&2
    bash scripts/get-aligned-transcript.sh "$tempdir" "$inaudiofn" > "$outfn"
    echo done >&2
done
