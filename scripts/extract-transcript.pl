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
    for (map { split /\W+/ } @$stenoarr) {
        say {$outfh} encode_utf8(lc) if /\w/;
    }
}
