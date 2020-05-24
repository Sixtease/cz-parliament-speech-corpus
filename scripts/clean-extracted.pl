#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
no warnings qw/qw/;
use 5.010;
use open qw(:std :utf8);
use Lingua::CS::Num2Words qw(
    num2cs_cardinal
    num2cs_ordinal
    num2cs_date
    num2cs_time
);

my $prev_line;
my $orig_line;
LINE:
while (<>) {
    s/\bč\./číslo/ig;
    s/\bresp\./respektive /ig;
    s/\batd./a tak dále /ig;
    s/\bhod\./hodin /ig;
    s/\btzn\./to znamená /ig;
    s/\bsb\./sbírky /ig;
    s/\bapod\./a podobně/ig;
    s/\bkč\./korun/ig;
    s{/}{ lomeno }g;

    if (s/.*§//) {
        say for qw(
            #BEGIN_ALTERNATIVES
            paragraf #
            paragrafu #
            paragrafů #
            paragrafem #
            paragrafech
            #END_ALTERNATIVES
        );
        redo LINE;
    }
    if (s/odst\.//) {
        say for qw(
            #BEGIN_ALTERNATIVES
            odstavec #
            odstavce
            #END_ALTERNATIVES
        );
        redo LINE;
    }
    if (s/.*tzv\.//) {
        say for qw(
            #BEGIN_ALTERNATIVES
            takzvané #
            takzvaných #
            takzvaný #
            takzvaného #
            takzvaně #
            takzvaná #
            takzvanou
            #END_ALTERNATIVES
        );
        redo LINE;
    }

    $orig_line = $_;
    s/(\S+)\s*//;
    my $head = $1;
    WORD:
    for ($head) {
        next WORD if not defined $_;
        next WORD if /hodin/ and $prev_line =~ /#\d/;
        if (/#\d+:\d+/) {
            print_alternatives(num2cs_time($_));
            next WORD;
        }
        elsif (/\d#\S+/) {
            print_alternatives(num2cs_date($_));
            next WORD;
        }
        if (/(\d+)\./) {
            print_alternatives(num2cs_ordinal($1));
            next WORD;
        }
        if (/\d+/) {
            (my $num = $head) =~ s/\D+$//;
            if ($prev_line =~ /číslo/) {
                my @genderarg = $num == 1 ? (gender => 'f') : ();
                print_alternatives(num2cs_cardinal(
                    @genderarg, case => 'nominative', $num,
                ));
            }
            elsif ($prev_line =~ /\bpřítome?n|\bpro(?:ti)?\b/) {
                print_alternatives(
                    num2cs_cardinal(
                        gender => 'g', case => 'nominative', $num,
                    ),
                    ($num == 1 ? 'jeden' : ()),
                );
            }
            elsif ($prev_line =~ /\bro[kc]/) {
                print_alternatives(num2cs_cardinal(
                    gender => 'g', case => 'nominative', skip_leading_one => 1, $num,
                ));
            }
            else {
                print_alternatives(num2cs_cardinal($num));
            }
            next WORD;
        }
        prt($_);
    }
    redo LINE if /\w/;
} continue {
    $prev_line = $orig_line;
}

sub print_alternatives {
    if (@_ == 1) {
        for my $word (split / /, $_[0]) {
            say $word;
        }
    }
    else {
        print '#BEGIN_ALTERNATIVES';
        for my $alternative (@_) {
            print "\n";
            for my $word (split / /, $alternative) {
                prt($word);
            }
            print '#';
        }
        say 'END_ALTERNATIVES';
    }
}

sub prt {
    for (@_) {
        for (split /\W+/) {
            next if not /\w/;
            say lc;
        }
    }
}
