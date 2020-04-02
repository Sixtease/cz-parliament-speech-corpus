#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.010;

use File::Basename qw(basename);

my ($wavinfn, $wavoutdir, $textoutdir) = @ARGV;

(my $stem = basename($wavinfn)) =~ s/\.wav//;

print STDERR $stem, ' ';

while (<STDIN>) {
    my ($start, $end, $text) = split /\t/;
    print STDERR $end, ' ';

    my $outbn = "$stem--from-$start--to-$end";

    my $textoutfn = "$textoutdir/$outbn.txt";
    open my $textoutfh, '>', $textoutfn
        or die "Cannot open '$textoutfn' for writing: $!";
    print {$textoutfh} $text;
    close $textoutfh;

    my $wavoutfn = "$wavoutdir/$outbn.wav";
    system('sox', $wavinfn, $wavoutfn, 'trim', $start, "=$end", qw(remix - rate 16k));
}

say STDERR '';
