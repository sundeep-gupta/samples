#!/usr/bin/env perl
use strict;
use warnings;
my $line = '8.10.1';
my $version = $line;
$version =~ s/^(\d+.\d+)/$1/;
print $version;
