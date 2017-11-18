#!/usr/bin/perl
use strict;
use lib $ENV{'HOME'}.'/utils';
use Utils;
my @series = ('EMGC_MAIN_LINUX.X64', 'EMGC_PT.12.1.0.4PLT_LINUX.X64');
foreach my $s (@series) {
    print "Refreshing $s\n";
    print "-----------------\n";
    &Utils::refresh_views($s);
}
