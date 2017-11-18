#!/usr/bin/env perl
use strict;
use warnings;
use lib $ENV{'HOME'}.'/utils';
use Utils;
use Data::Dumper;
my $farm_loc = $ARGV[0];
my $ra_lrgs = &Utils::get_lrg_names($farm_loc);
foreach my $lrg (@$ra_lrgs) {
    print "Checking hostname for $lrg ...";
    unless (-e "$farm_loc/$lrg/test.properties.log") {
        print " ERROR: test.properties.log not found.\n";
        next;
    } 
    open (my $fh, "$farm_loc/$lrg/test.properties.log");
    my @content = <$fh>;
    chomp @content;
    close ($fh);
    my @host = grep {$_ =~ /^EM_HOST=/} @content;
    my $host = (split(/=/, $host[0]))[1];
    print "$host\n";
}
