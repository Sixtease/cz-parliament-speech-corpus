#!/bin/bash

# expects:
#   - $PP_source_datadir/*.{wav,trs}
#   - $EV_wordlist_test

if [ -e "$EV_wordlist_test" ]; then : ; else
    echo '$EV_wordlist_test' not found
    exit 1
fi

if ls "$PP_source_datadir"/*.trs > /dev/null; then : ; else
    echo '$PP_source_datadir/*.trs' not found
    exit 1
fi

if ls "$PP_source_datadir"/*.wav > /dev/null; then : ; else
    echo '$PP_source_datadir/*.wav' not found
    exit 1
fi

bash scripts/mktrain.sh
bash scripts/separate-test-set.sh 100

perl scripts/txt2mlf.pl data/train/txt > "$EV_train_transcription"
perl scripts/txt2mlf.pl data/test/txt > "$EV_test_transcription"

perl scripts/mlf2wordlist.pl < "$EV_train_transcription" > data/dict/train.dict

pushd ..
bash scripts/mkphondict.sh < "$OLDPWD"/data/dict/train.dict > "$OLDPWD"/data/dict/train.phon.dict
popd
