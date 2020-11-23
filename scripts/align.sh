#!/bin/bash

stem="$1"

bash scripts/strip-timestamps.sh < data/recout/$stem.recout > data/work/split/$stem.txt
python scripts/match-lines.py data/work/split/$stem.txt data/extracted/$stem.txt data/disambiguated/$stem.txt > data/work/matched-lines/$stem.txt
python scripts/assign-timestamps.py data/disambiguated/$stem.txt data/recout/$stem.recout < data/work/matched-lines/$stem.txt
rm data/work/split/$stem.txt data/work/matched-lines/$stem.txt
