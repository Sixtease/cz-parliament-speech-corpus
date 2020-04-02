#!/bin/bash

export PP_source_datadir=downloads/lindat
export PP_ASR_ROOT=`pwd`
export PP_txtdir="$PP_ASR_ROOT/data/train/txt"
export PP_wavdir="$PP_ASR_ROOT/data/train/wav"

export ASR_ROOT="$PP_ASR_ROOT"
export EV_homedir="$PP_ASR_ROOT/lib/Evadevi/"

export RECOUTDIR="$PP_ASR_ROOT/../data/recout"
export REC_WORKDIR="$PP_ASR_ROOT/data/work"

export PATH="${EV_homedir}bin:$PATH"

export EV_workdir="$PP_ASR_ROOT/data/work/"
export EV_outdir="$PP_ASR_ROOT/hmms/"

export EV_encoding='iso-8859-2'

export EV_train_mfcc="$PP_ASR_ROOT/data/train/mfcc"
export EV_wordlist_train_phonet="$PP_ASR_ROOT/data/dict/train.phon.dict"
export EV_train_transcription="$PP_ASR_ROOT/data/transcript/train.mlf"
export EV_LMf="$PP_ASR_ROOT/../data/lm/tg.arpa"
export EV_LMb="$PP_ASR_ROOT/../data/lm/tgb.arpa"
export EV_wordlist_test_phonet="$PP_ASR_ROOT/../data/dictionary/test.phon.dict"
export EV_tree_hed="$PP_ASR_ROOT/resources/tree.hed"
export EV_triphone_questions="$EV_tree_hed"

export EV_test_transcription="$PP_ASR_ROOT/data/transcript/test.mlf"
export EV_test_mfcc="$PP_ASR_ROOT/data/test/mfcc"
export EV_wordlist_test="$PP_ASR_ROOT/../data/dictionary/test.dict"

export EV_use_triphones='1'
export EV_min_mixtures=15

export EV_HERest_p=8

export EV_HVite_p='8.0'
export EV_HVite_s='6.0'
export EV_HVite_t='150.0'

export EV_iter_init=2
export EV_iter_sp=2
export EV_iter_align=2
export EV_iter_var=2
export EV_iter_triphones=3
export EV_iter_mixtures=4

export EV_thread_cnt=4
export EV_heldout_ratio=40

export EV_evaluate_steps=1

export TEMPDIR="$PP_ASR_ROOT/temp"

export TEST_DICT_SIZE=65000

export EIGEN3_ROOT=/home/sixtease/km/sg/asr/tools/eigen/eigen-eigen-07105f7124f9

export AUDIO_CORPUS_DIR=/media/sixtease/pavouk/corpora/cs/parlament/data/original/audio

. "${EV_homedir}config.sh"

alias i="iconv -f $EV_encoding -t utf8"
