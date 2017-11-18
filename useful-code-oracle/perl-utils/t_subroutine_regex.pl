#!/usr/bin/env perl
use strict;
use warnings;

my $regex_subrtn = 'sub( [^*]?)(\{*)';

my @surbroutines = (
    'sub myfunc',
    'sub       myfunc',
    '    sub myfunc',
    'sub myfunc {',
    'sub myfunc{',
    'sub     myfunc     {',
    '     sub   myfunc {',
    'my $myfunc = sub {',
    'my $myfunc     =    sub    {',
    'my $myfunc = sub',
    'my $myfunc = sub{',
    'my $myfunc = sub    ',
);

foreach my $sub (@surbroutines) {
    if ($sub =~ /$regex_subrtn/) {
        printf "%30s: PASS\n", '\''.$sub.'\'';
    }
    else {
        printf "%30s: FAIL\n", '\''.$sub.'\'';
    }
}
print"\n";
