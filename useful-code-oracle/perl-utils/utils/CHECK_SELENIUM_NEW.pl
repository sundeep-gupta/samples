#!/usr/bin/env perl
use strict;
my $line = '$selenium->start;';
if ($line =~ /\s*(\w+)->start\(?\)?;/) {
  print $1;
}
print "Done!\n";
