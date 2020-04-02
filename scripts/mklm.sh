#!/bin/bash

perl scripts/get-scraped-utterances.pl < downloads/scraped.json \
  | perl scripts/utterances-to-corpus.pl \
  > data/lm/corpus.utf8

iconv -f utf8 -t iso-8859-2 < data/lm/corpus.utf8 > data/lm/corpus.latin2

perl -nlE 'print join " ", reverse split / /' \
    < data/lm/corpus.latin2 > data/lm/corpusb.latin2

echo '<s>' > data/dictionary/test.dict
echo '</s>' >> data/dictionary/test.dict
cat data/lm/corpus.utf8 \
  | tr ' ' "\n" | grep . | sort | uniq -c | sort -nrk 1 | tr -s ' ' | cut -d ' ' -f 3 \
  | head -n 63000 \
  | iconv -f utf8 -t iso-8859-2 \
  >> data/dictionary/test.dict

lmplz \
  --limit_vocab_file data/dictionary/test.dict \
  -o 3 \
  < data/lm/corpus.latin2 \
  > data/lm/tg.kenlmorder.arpa

lmplz \
  --limit_vocab_file data/dictionary/test.dict \
  -o 3 \
  < data/lm/corpusb.latin2 \
  > data/lm/tgb.kenlmorder.arpa

perl scripts/julutil.pl sort_lm < data/lm/tg.kenlmorder.arpa  > 'data/lm/tg.arpa'
perl scripts/julutil.pl sort_lm < data/lm/tgb.kenlmorder.arpa > 'data/lm/tgb.arpa'

bash scripts/mkphondict.sh < data/dictionary/test.dict \
  | head -n 65000 > data/dictionary/test.phon.dict
