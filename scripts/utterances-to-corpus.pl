#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.010;

use Encode qw(encode decode_utf8 encode_utf8);

while (<>) {
    for (uc decode_utf8 $_) {
        y/Ö/É/;
        y/Ä/E/;
        y/Ü/Y/;
        y/Ł/L/;
        y/Ń/N/;
        y/Ć/Č/;
        s/[^AÁBCČDĎEÉĚFGHIÍJKLMNŇOÓPQRŘSŠTŤUÚŮVWXYÝZŽ ]+/ /g;
        s/\s{2,}/ /g;
        s/^\s+//;
        s/\s+$//;
        next if not /\S/;
        say encode_utf8 $_;
    }
}
