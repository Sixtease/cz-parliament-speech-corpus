#!/bin/bash

while read filename; do
  stem=`basename "$filename" | sed 's/\.[^.]*$//'`
  mkdir data/splits/"$stem" || continue
  echo $stem
  echo $stem >&2
  bash scripts/align.sh "$stem" > data/aligned/"$stem".tsv
  perl scripts/find-splits-by-slen.pl < data/aligned/"$stem".tsv > data/splitpoints/"$stem".txt
  python scripts/generate-split-params.py data/splitpoints/"$stem".txt < data/aligned/"$stem".tsv > data/splitparams/"$stem".tsv
  bash scripts/split-by-params.sh data/splitparams/"$stem".tsv
done
