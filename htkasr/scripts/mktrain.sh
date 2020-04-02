#!/bin/bash

indir="${1:-$PP_source_datadir}"
textoutdir="${2:-$PP_ASR_ROOT/data/train/txt}"
wavoutdir="${3:-$PP_ASR_ROOT/data/train/wav}"
mfccoutdir="${4:-$PP_ASR_ROOT/data/train/mfcc}"

cluck() { echo $* >&2; }

cluck generating wavs and text
find "$indir/" -name '*.trs' | while read trsfn; do
  cluck $trsfn
  wavfn="`echo $trsfn | sed 's/\.trs/.wav/'`"
  perl scripts/get-utterances.pl < "$trsfn" \
    | perl scripts/save-utterances.pl "$wavfn" "$wavoutdir" "$textoutdir"
done

cluck generating mfcc
bash scripts/wav-to-mfcc.sh "$wavoutdir" "$mfccoutdir"
