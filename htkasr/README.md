# Building acoustic model for initial transcription

## Prerequisities

- Trigram ARPA language model in `../data/lm/tg.arpa`, `../data/lm/tgb.arpa`
- iso-latin-2 dictionary in `../data/dictionary/test.dict`.
- HTK binaries in PATH
- julius binary in PATH

## Preparation

The Czech Parliament Meetings Lindat data are expected in
`downloads/lindat/`.

You can use the following command to download them:

```
mkdir downloads/lindat
pushd downloads/lindat
curl --remote-name-all https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4{/SOUND_110212_003546.trs,/SOUND_110212_003546.wav,/SOUND_110325_010705.trs,/SOUND_110325_010705.wav,/SOUND_110427_005836.trs,/SOUND_110427_005836.wav,/SOUND_110428_005954.trs,/SOUND_110428_005954.wav,/SOUND_110429_005820.trs,/SOUND_110429_005820.wav,/SOUND_110504_005351.trs,/SOUND_110504_005351.wav,/SOUND_110505_005813.trs,/SOUND_110505_005813.wav,/SOUND_110506_005821.trs,/SOUND_110506_005821.wav,/SOUND_110507_005803.trs,/SOUND_110507_005803.wav,/SOUND_110511_005438.trs,/SOUND_110511_005438.wav,/SOUND_110609_005958.trs,/SOUND_110609_005958.wav,/SOUND_110611_010015.trs,/SOUND_110611_010015.wav,/SOUND_110617_010946.trs,/SOUND_110617_010946.wav,/SOUND_110618_010259.trs,/SOUND_110618_010259.wav,/SOUND_110619_001010.trs,/SOUND_110619_001010.wav,/SOUND_110714_010025.trs,/SOUND_110714_010025.wav,/SOUND_110715_005912.trs,/SOUND_110715_005912.wav,/SOUND_110831_005909.trs,/SOUND_110831_005909.wav}
popd
```

In the `lib/` directory, clone Evadevi from github:

```
cd lib
git clone https://github.com/Sixtease/Evadevi.git
```

Source the config file

`. config.sh`

Run the data-preparation script

`bash scripts/1-prepare-data.sh`

## Training

Run the trainig script

`bash scripts/2-train.sh`

If everything goes fine, you should reach a point where the splitting reaches
a maximum and then starts diminishing. When you see you're past the maximum
score, kill the training
