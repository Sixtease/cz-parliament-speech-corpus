#!/bin/bash

: ${PROCESSOR_COUNT:=`nproc`}
: ${PART_LENGTH:=60}
: ${AUDIO_CORPUS_DIR:=downloads/audio}
: ${RECOUTDIR:=data/recout}
: ${REC_WORKDIR:=data/work/initial-transcription}

find "$AUDIO_CORPUS_DIR/" -name '*.mp3' | while read mp3fn; do
  stem=`basename "$mp3fn" | sed 's/.mp3$//'`
  outfn="$RECOUTDIR/$stem.recout"
  tempdir="$REC_WORKDIR/$stem"

  if [ -e "$outfn" ]; then
      echo "$outfn exists; skipping"
      continue
  fi
  mkdir "$tempdir" || continue

  echo "-> $stem " >&2
  sox "$mp3fn" "$tempdir/rec.wav" rate 16k trim 0 $PART_LENGTH : newfile : restart
  i=0
  for wavfn in "$tempdir"/rec*; do
    echo " -> $wavfn " >&2

    partstem=`echo "$wavfn" | sed s/\.wav//`
    HCopy -C "resources/htk-config-wav2mfcc-full" "$wavfn" "$partstem.mfcc"
    echo "$partstem.mfcc" > "$partstem.scp"

    julius -h data/hmms/hmmmodel -filelist "$partstem.scp" -nlr data/lm/tg.arpa -nrl data/lm/tgb.arpa -v data/dictionary/test.phon.dict -hlist data/hmms/phones -walign -input mfcfile -fallback1pass > "$partstem.julout" 2>logs/initial-transcription/"$stem" &

    if ((++i % PROCESSOR_COUNT == 0)); then wait; fi
  done
  wait

  perl scripts/julutil.pl aggregate-julout $PART_LENGTH "$tempdir"/*.julout > "$outfn"
  #rm "$tempdir"/*
  echo done >&2
done
