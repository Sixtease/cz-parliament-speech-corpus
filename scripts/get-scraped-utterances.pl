#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.010;

use JSON::XS qw(decode_json);
use Encode qw(encode_utf8);

while (<>) {
    /steno/ or next;
    chomp;
    { local $/ = ','; chomp; } # get rid of trailing comma
    my $parsed = decode_json($_);
    for (@{ $parsed->{steno} }) {
        next unless /\S/;
        s/^\s+//;
        s/\s+$//;
        say encode_utf8($_);
    }
}
