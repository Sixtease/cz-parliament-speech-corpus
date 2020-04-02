#!/bin/bash

stem="$1"

bash scripts/strip-timestamps.sh < data/recout/$stem.recout > data/work/split/$stem.txt
python scripts/match-lines.py data/work/split/$stem.txt data/extracted/$stem.txt \
  | python scripts/assign-timestamps.py data/extracted/$stem.txt data/recout/$stem.recout \
  | python scripts/guess-silence-length.py
rm data/work/split/$stem.txt
