#!/usr/bin/env perl
use strict;
my $file = $ENV{'T_WORK'}.'/test.properties.log';
open(my $fh, $file);
my @lines = <$fh>;
close $fh;
chomp @lines;
foreach my $line (@lines) {
    if ($line=~ /EM_COUNTRY=(.*)/) {
        print $1, "\n";
        my $var = $1;
        $var =~ s/^\s+//;
        $var =~ s/\s+$//;
        $var =~ tr/A-Z/a-z/;
        print $var;
    }
}

