#!/bin/bash

split_by() {

  audiostart="$1"
  audioend="$2"
  startline="$3"
  endline="$4"

  d=data/splits/"$stem"
  id="$stem--from-$audiostart--to-$audioend"

  sox downloads/audio/"$stem".mp3 "$d/$id.wav" trim "$audiostart" ="$audioend" rate 16k
  perl -nE "print if $startline .. $endline" < data/extracted/"$stem".txt | xargs echo > "$d/$id.txt"

}

for s in "$@"; do
  stem=`basename "$s" | sed s/.tsv//`
  while read line; do
    split_by $line
  done < "$s"
done
