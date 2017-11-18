#!/usr/bin/env perl
use strict;

my $file = $ARGV[0];
open(my $fh, $file);
my @content = <$fh>;
close($fh);
chomp @content;

my @tests_with_timeout = grep { $_ =~ /total\sdownload\stime\s=\s\d\d\./;} @content;
print @tests_with_timeout;

