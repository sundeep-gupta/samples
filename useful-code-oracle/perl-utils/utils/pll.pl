#!/usr/bin/env perl
use strict;
my @output = `ls -lrt *.dif`;
foreach my $line (@output) {
   my @arr = (split(/\s+/, $line));
   print $arr[$#arr], "\n";
}
