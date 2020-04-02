Aligning long audio with transcript based on forced-aligned ASR result.

The main script to run is `scripts/split.sh`. It expects on STDIN one filename
to process per line.

## Input

Input files are expected in three directories:

*  downloads/audio
*  data/extracted
*  data/recout

downloads/audio should contain audio files named `$id.mp3`.

data/extracted should contain the gold-standard transcripts one word per line.
The files should be named `$id.txt`.

data/recout should contain aligned result of ASR inference. The expected format
is `start end word`. Timestamps are in seconds, fields separate by space.

## Output

The output is stored in four directories:

*  data/aligned
*  data/splitpoints
*  data/splitparams
*  data/splits

data/aligned contains the three-way alignment of the audio, the automatic
transcripts and the manual one. Each file is named `$id.tsv` and contains seven
tab-separated fields:

1. start position (in seconds),
2. end position,
3. predicted trailing silence length,
4. predicted word,
5. manual word,
6. line in manual transcript,
7. alignment certainty.

The alignment between the two transcripts is done by computing Levenshtein
edit operations. The alignment certainty is then the number of edits on the
given line divided by its length in characters.

data/splitpoints contains splitpoints for each file, one per line, so that
each chunk is between 12 and 30 seconds of length and so that the longest
available pauses are chosen. The split point is always selected into the middle
of the predicted silence, up to a maximum of one second before the next word.

The length between 12 and 30 seconds is chosen so that 1. there is a good chance
of finding a reliable silence and 2. the chunks are not too long for training.

data/splitparams contains lines with four tab-separated fields: audio chunk
start, audio chunk end, starting line, final line. The lines refer to the manual
stenographic transcripts.

data/splits contain directories, one per recording. Each directory contains
audio and text files named `$id--from-$start--to-$end.wav` and
`$id--from-$start--to-$end.txt`. The txt files contain the transcript without
punctuation, all lowercase, on a single line.
