#!/usr/bin/env perl
use strict;
use Data::Dumper;
my $farm = $ARGV[0];

my $ra_lrgs = &get_all_lrgs($farm);
foreach my $lrg (@$ra_lrgs) {
    print $lrg, " ";
}
#print Dumper($ra_lrgs);
#print scalar(@$ra_lrgs);

sub get_all_lrgs {
    my ($farm) = @_;
    return [] unless -e $farm;
    opendir(my $dh, $farm);
    my @dircontent = grep { $_ ne '.' and $_ ne '..' and -d "$farm/$_" and -e "$farm/$_/selenium_server.0.log"; }readdir($dh);
    closedir($dh);
    return \@dircontent;
}
