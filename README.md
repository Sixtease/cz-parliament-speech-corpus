# Czech Parliament Meetings for Speech Recognition

## Introduction

A set of tools to generate training data suitable for text-to-speech systems
out ot the recorded parliamentary meetings and their stenographic transcripts.

This dataset is quite large (about 200GB downloadable mp3's) and in public
domain. The transcripts are manual but not 100% literal, though the precision is
very good. The major downsides are a complete lack of machine-readable metadata
and only very loose alignment.

There is a small set of these transcribed recordings made available as a richly
annotated corpus for speech recognition by the University of West Bohemia in
Pilsen. The set is available through Lindat / Clarin under the name "Czech
Parliament Meetings" and it can be used to train a seed model.

The goal is to have couples wav-file -- txt-file under 30 seconds of length.
What we start with is a website with HTML-formatted text and links to mp3's.
The scheme is as follows:

1.  scrape the transcripts coupled to their corresponding mp3 urls,
2.  download all the mp3's,
3.  train a seed model using the Pilsen dataset,
4.  automatically transcribe the mp3's using the seed model keeping word-level
    forced alignment,
5.  align the automatic transcript with the manual one,
6.  generate chunks aligned with reliable manual transcripts.

## Preparation

### Python modules scrapy, Levenshtein

Install scrapy to scrape the transcripts and URLs of their corresponding audio
recordings.

```
virtualenv -p python3 parliament
. parliament/bin/activate
pip install scrapy python-levenshtein
```

### julius

Install [julius](https://github.com/julius-speech/julius) for the initial
aligned transcript.

### HTK

You'll need the [HTK](https://github.com/loretoparisi/htk).
(HMM ToolKit) if you want to train your own acoustic
model for the initial transcription. You'll need the program HCopy from HTK to
run the initial transcription.

### models for initial transcription

To get the initial transcript, you need julius and an acoustic and a language
model. You can either download the
[model package](https://uloz.to/file/lD4AP9DDEDgI/cz-parliament-speech-corpus-resources-zip)
and extract it here or you can build it yourself with HTK.

### Other dependencies

Please install a recent enough version of **wget**, so it can cope with HTTPS
redirects.

Install **sox** with mp3 support.

Install **kenlm** so that the binary `lmplz` is in the PATH.

Get the Perl module **JSON::XS**.

## Get the data

The recordings and their transcripts are available from the website
of the parliament: [psp.cz/eknih](https://www.psp.cz/eknih/).

The transcripts and their corresponding mp3 URLs can be scraped from
the parliament web by the scrapy scraper.

```
scrapy runspider -o downloads/scraped.json scripts/scrape.py
```

To download the mp3's, use `download-scraped-audio.sh`:

```
bash scripts/download-scraped-audio.sh downloads/scraped.json
```

Never mind the 404s. The earlier recordings simply seem to be missing. The
result should be about 17000 files. The download will likely take a few hours or
even days depending on your connection quality.

The mp3s will be downloaded into the directory `downloads/audio`. If you
want to download it someplace else, please use a symlink.

## Language Model

You'll need a trigram language model in ARPA format if you plan to

1. make an initial aligned transcription,
2. build an acoustic model for the purposes of initial transcription,
3. use the final model with an engine that requires one, like Mozilla's
   DeepSpeech.

So you probably do need a language model. You can download it along with the
acoustic model or you can build it yourself.

To build the language model, you'll need the scraped data from the above section
(`downloads/scraped.json`) and the package **kenlm**.

```
bash scripts/mklm.sh
```

## Initial Transcription

An initial transcription is necessary for alignment of the stenographs with the
recordings. We use HTK for training, Julius for inference and the
[Parliament Meetings corpus released by University of West Bohemia through Lindat/Clarin](https://lindat.mff.cuni.cz/repository/xmlui/handle/11858/00-097C-0000-0005-CF9C-4)
as training data.

If you prefer to build your own acoustic model for the initial transcription,
see the directory `htkasr`.

Once you have the acoustic and language model (trained or downloaded), you can
proceed to use julius to get the initial transcript:

```
. config.sh
bash scripts/initial-transcription.sh
```

Note that this stage takes by far the longest. It will use all the processors
available. You can affect the number of processors used by setting the
environment variable `PROCESSOR_COUNT`.

#### Aligning

Generating couples of sentence-level audio files and their transcripts is the
final step in preparing engine-agnostic data for speech recognition. So far we
have original 14-minute MP3's, manual transcripts corresponding roughly to
middle 10 minutes, and word-level-aligned automatic transcripts. Hence, we 1.
create an alignment between the audio-aligned automatic transcript and the
manual transcript, 2. split to chunks surrounded by silences, 3 select reliable
chunks and 4. generate their wav-text file couples.

It is first necessary though to extract the transcripts:

```
export OUTDIR=data/extracted
perl scripts/extract-transcript.pl < downloads/scraped.json
```

Then run `ls data/recout/* | bash scripts/split.sh`.

The results are stored in `data/splits`. Make sure there is enough space in this
directory, as the corpus will be saved in 16kHz wav format (2:1 to original mp3
files).

For more detail on aligning, see [README-aligning.md](README-aligning.md).
