#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use 5.010;
use Encode qw(decode encode_utf8);

my $last_sync = 0;
my @buffer;

while (<>) {
    my $line = decode 'cp-1250', $_;
    if (/<Sync\b[^>]*\btime="([^"]+)"/) {
        my $current_sync = $1;
        flush($current_sync);
        next;
    }
    if (/<Event\b[^>]*\btype="pronounce"/) {
        apply_pronunciation($line);
        next;
    }
    if (/^[^<]/) {
        chomp;
        push @buffer, $line;
        next;
    }
}

sub flush {
    my ($end_pos) = @_;
    my $start_pos = $last_sync;
    my $txt = join(' ', @buffer);
    $txt =~ s/\s+/ /g;
    $txt =~ s/^\s+//;
    $txt =~ s/\s+$//;
    if ($txt =~ /\S/) {
        say encode_utf8 join "\t", $start_pos, $end_pos, $txt;
    }
    $last_sync = $end_pos;
    @buffer = ();
}

sub apply_pronunciation {
    my ($start_tag) = @_;
    return if $start_tag !~ /extent="begin"/;
    $start_tag =~ /desc="([^"]+)"/ or warn("no pronunciation on line $.: $start_tag"), return;
    push @buffer, $1;
    while(<>) {
        last if /<Event/ and /type="pronounce"/ and /extent="end"/;
    }
}
