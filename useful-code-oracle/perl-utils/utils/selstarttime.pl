#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use lib $ENV{'HOME'}.'/utils';
use SeleniumBrowserStartLogParser;
use Data::Dumper;

my $results = $ARGV[0];
die "$results does not exist." unless -e $results;
opendir (my $dh, $results);
my @list = readdir($dh);
closedir $dh;
my @filtered = grep { -d "$results/$_" and -e "$results/$_/selenium_browser_start.log"; } @list;
my $rh_results = {};
foreach my $dir (@filtered) {
    #next unless $dir =~ /srg/;
    my $obj = SeleniumBrowserStartLogParser->new($results.'/'.$dir);#print Dumper($obj);
    if ($obj->{'start'} and $obj->{'end_time'}) {
        $rh_results->{$dir} = [$obj->{'start'}, $obj->{'end_time'}];
    } else {
#        $rh_results->{$dir} = 'no data';
    }
}
print Dumper($rh_results);
