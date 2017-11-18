#!/usr/bin/env perl
use strict;
use warnings;
use lib $ENV{'HOME'}.'/utils';
use Utils;
use Data::Dumper; 


my $debug = 1;
my $result_loc = $ARGV[0];
die "$result_loc does not exist\n" unless -e $result_loc;
my @ls_filtered = &Utils::get_lrgs_running_new_framework($result_loc);
my $rh_broken_pipe = &Utils::scan_issue_in_testlog(\&check_getnewbrowser, $result_loc, \@ls_filtered, $debug);
print Dumper($rh_broken_pipe);



sub check_getnewbrowser {
    my ($file) = @_;
    open(my $fh, $file) or do { print "Failed to open file $file : $!\n"; return; };
    my @content = <$fh>;
    close $fh;
    return grep {$_ =~ /Fatal Error requesting/ or $_ =~ /Server closed connection/;} @content;
}

