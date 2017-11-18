#!/usr/bin/env perl

use strict;
use warnings;

my $file = $ARGV[0];

die "File $file does not exist.\n" unless -e $file;
open( my $fh, $file);
my @content = <$fh>;
close $fh;
my $count = 0;
my $sum = 0;
foreach my $line (@content) {
    if ($line =~ /Time\staken\sby\smodule\s'get_resource_value'\sis\s(\d+\.\d+)\s+\(seconds\)/) {
        $count++;
        $sum+= $1;
    }
}
printf "Total Time: %.3f\nAverage time : %.3f\nTotal instances : %d\n", $sum, $sum/$count, $count;
