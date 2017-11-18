#!/usr/bin/env perl
use strict;
my $path = $ENV{'LD_LIBRARY_PATH'};
print $path,"\n";
$path =~ s#/usr/local/packages/firefox#/usr/lib:/usr/local/packages/firefox#;
print $path, "\n";
