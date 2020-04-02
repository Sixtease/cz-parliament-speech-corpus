#!/bin/bash

INDIR="$1"
OUTDIR="$2"
: ${HTK_WAV_TO_MFCC_CONF:="${EV_homedir}resources/htk-config-wav2mfcc-full"}

for wav in "$INDIR"/*.wav; do
  s=`basename "$wav"`;
  stem=`echo $s | sed "s/\.wav$//"`;
  echo $stem >&2
  HCopy -C "$HTK_WAV_TO_MFCC_CONF" "$wav" "$OUTDIR/$stem.mfcc"
done

