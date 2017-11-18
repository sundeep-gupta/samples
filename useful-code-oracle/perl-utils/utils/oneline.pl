#!/usr/bin/env perl
use strict;
use warnings;

my $file = $ARGV[0];
my $sep = $ARGV[1] || ' ';
open (my $fh, $file);
my @content = <$fh>;
close $fh;
chomp @content;
my $content = join ($sep, @content);

open ( $fh, ">$file.oneline");
print $fh $content;
close $fh;
