#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use 5.010;

use Encode qw(encode_utf8);

use JSON::XS qw(decode_json);

my $outdir = $ENV{OUTDIR} || '.';

while (<>) {
    my ($mp3bn) = m{"mp3url"\s*:\s*"[^"]*/([^/"]+)"} or next;
    (my $stenojson = $_) =~ s/^\{"steno"\s*:\s*//;
    $stenojson =~ s/,\s*"mp3url.*//;
    my $stenoarr = decode_json($stenojson);
    (my $txtbn = $mp3bn) =~ s/mp3/txt/;
    warn "$mp3bn\n";
    open my $outfh, '>', "$outdir/$txtbn" or die;
    for (@$stenoarr) {
        s/(?<=\d)\x{a0}(?=\d)//g; # 20 000 => 20000
        s/\b(\d+)\.\s*(\w+)\.?\s+(\d\d\d\d)\b/ $1#$2#$3 /g; # 22. 3. 2019 => 22#3#2019
        s/\b(\d{1,2})\.\s+(\d{1,2})\./ $1#$2 /g;   # 22. 3. => 22#3
        s/\b(\d+)\.\s*((?:le|ún|bř|du|kv|č|sr|zá|ří|li|pr)\w*)'/ $1#$2 /g;   # 22. března => 22#března
        s/\b(\d{1,2})\.(\d{1,2}\b)/ #$1:$2 /g;    # 12.45 => #12:45
        s/(?<=\d)\s*mil\./000000/g;
        s/(?<=\d)\s*mld\./000000000/g;

        # mark end of sentence with double semicolon to prevent confusion
        # ordinal numbers and abbreviations
        s/\.\s*(?=[[:upper:]])/;; /g;
        s/\.$/;;/;
    }

    for (map { split /\s+/ } @$stenoarr) {
        say {$outfh} encode_utf8($_) if /\w/;
    }
}
