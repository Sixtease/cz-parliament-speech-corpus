#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.010;

use Encode qw(encode);
use File::Basename qw(basename);

my $indir = pop;
my $encoding = $ENV{MLF_ENCODING} || 'iso-8859-2';

say '#!MLF!#';

for my $infn (<$indir/*>) {
    (my $stem = basename $infn) =~ s/\.\w+$//;
    say qq("*/$stem.lab");

    open my $infh, '<:utf8', $infn or die "Cannot open '$infn': $!";
    while (<$infh>) {
        my $l = uc;
        $l =~ s/[^AÁBCČDĎEÉĚFGHIÍJKLMNŇOÓPQRŘSŠTŤUÚŮVWXYÝZŽ ]//g;
        my @words = split /\s+/, $l;
        say encode($encoding, $_) for @words;
        say '.';
    }
    close $infh;
}
