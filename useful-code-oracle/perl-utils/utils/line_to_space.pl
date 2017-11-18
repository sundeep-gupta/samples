#!/usr/bin/env perl
use strict;
my $file = $ARGV[0];

die "No file $file" unless $file and -e $file;
open (my $fh, $file);
my @lines = <$fh>;
close $fh;
chomp @lines;
print join (' ', @lines);
