#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use 5.010;

while (<>) {
    /"mp3url"\s*:\s*"([^"]+)"/ and say $1;
}
