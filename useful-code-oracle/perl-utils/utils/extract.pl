#!/usr/bin/env perl

use strict;
use Archive::Extract;
use warnings;

my $archive_file = $ARGV[0];
my $ae = Archive::Extract->new(archive => $archive_file);
$ae->extract(to => $ENV{'T_WORK'});

