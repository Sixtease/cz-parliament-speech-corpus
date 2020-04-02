#!/bin/bash

PROCESSOR_COUNT=`nproc`
: ${pc:="$PROCESSOR_COUNT"}

: ${PART_LENGTH:=60}

find "$AUDIO_CORPUS_DIR/" -name '*.mp3' | while read mp3fn; do
  stem=`basename "$mp3fn" | sed 's/.mp3$//'`
  outfn="$RECOUTDIR/$stem.recout"
  tempdir="$REC_WORKDIR/$stem"

  mkdir "$tempdir" || continue

  echo "-> $stem " >&2
  sox "$mp3fn" "$tempdir/part.wav" rate 16k trim 0 $PART_LENGTH : newfile : restart
  i=0
  for wavfn in "$tempdir"/part*; do
    echo " -> $wavfn " >&2

    partstem=`echo "$wavfn" | sed s/\.wav//`
    HCopy -C "$EV_homedir/resources/htk-config-wav2mfcc-full" "$wavfn" "$partstem.mfcc"
    echo "$partstem.mfcc" > "$partstem.scp"

    julius -h hmms/hmmmodel -filelist "$partstem.scp" -nlr generated-data/lm/tg.arpa -nrl generated-data/lm/tgb.arpa -v generated-data/dict/test.phon.dict -hlist hmms/phones -walign -input mfcfile -fallback1pass > "$partstem.julout" 2>/dev/null &

    if ((++i % pc == 0)); then wait; fi
  done
  wait

  perl "$EV_homedir"bin/julutil.pl aggregate-julout $PART_LENGTH "$tempdir"/*.julout > "$outfn"
  rm "$tempdir"/*
  echo done >&2
done
