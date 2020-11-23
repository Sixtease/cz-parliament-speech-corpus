#!/bin/bash

: ${PROCESSOR_COUNT:=`nproc`}
: ${PART_LENGTH:=60}

tempdir="$1"
inaudiofn="$2"

refuse() {
    echo "directory '$tempdir' already exists; exiting" >&2
    exit 1
}

audiolen=`soxi -D "$inaudiofn"`
floorlen=${audiolen%.*}
start=0
end=$PART_LENGTH
while ((start < floorlen)); do
  if ((end >= floorlen)); then
      sox "$inaudiofn" "$tempdir/rec--from-$start--to-end.wav" remix - rate 16k trim $start
  else
      sox "$inaudiofn" "$tempdir/rec--from-$start--to-$end.wav" remix - rate 16k trim $start $PART_LENGTH
  fi
  start=$((start + PART_LENGTH))
  end=$((start + PART_LENGTH))
done
i=0
for wavfn in "$tempdir"/rec*; do
  echo " -> $wavfn " >&2

  partstem=`echo "$wavfn" | sed s/\.wav//`
  bin/HCopy -C "resources/htk-config-wav2mfcc-full" "$wavfn" "$partstem.mfcc"
  echo "$partstem.mfcc" > "$partstem.scp"

  bin/julius -h resources/hmmmodel -filelist "$partstem.scp" -nlr resources/tg.arpa -nrl resources/tgb.arpa -v resources/test.phon.dict -hlist resources/phones -walign -palign -input mfcfile -fallback1pass > "$partstem.julout" 2>/dev/null &

  if ((++i % PROCESSOR_COUNT == 0)); then wait; fi
done
wait

perl bin/julutil.pl aggregate-julout $PART_LENGTH "$tempdir"/*.julout
rm "$tempdir"/*
