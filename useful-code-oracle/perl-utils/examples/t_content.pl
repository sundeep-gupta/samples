#!/usr/bin/perl

use strict;
use Data::Dumper;
my $content = "|asdf|23423|zscv|qw3|";
my @arr = split("\\|", $content);
print Dumper(\@arr);
