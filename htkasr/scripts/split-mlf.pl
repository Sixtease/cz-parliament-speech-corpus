#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.010;

my $trainfn = shift;
my $heldoutfn = shift;

open my $trainfh  , '>', $trainfn   or die $!;
open my $heldoutfh, '>', $heldoutfn or die $!;

my $header = scalar <>;
print {$trainfh  } $header;
print {$heldoutfh} $header;

while (<>) {
    if ($. % $ENV{EV_heldout_ratio} == $ENV{EV_heldout_ratio} - 1) {
        print {$heldoutfh} $_;
    }
    else {
        print {$trainfh} $_;
    }
}
