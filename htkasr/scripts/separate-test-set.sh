#!/bin/bash

if [ -e "$REC_WORKDIR/test-set" ]; then : ; else
    ls data/train/txt | shuf | head -n "$1" | sed 's/\.txt$//' > "$REC_WORKDIR/test-set"
fi

while read stem; do mv data/train/txt/"$stem.txt"   data/test/txt/;  done < "$REC_WORKDIR/test-set"
while read stem; do mv data/train/wav/"$stem.wav"   data/test/wav/;  done < "$REC_WORKDIR/test-set"
while read stem; do mv data/train/mfcc/"$stem.mfcc" data/test/mfcc/; done < "$REC_WORKDIR/test-set"
