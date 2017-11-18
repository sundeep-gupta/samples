#!/usr/bin/env perl
use strict;
use Data::Dumper;
use lib $ENV{'HOME'}.'/utils';

use SeleniumCmdParse;
my $file_loc = $ARGV[0];
my $obj = SeleniumCmdParse->new($file_loc);
my $ra_tests = $obj->get_tests();
my $rh_sessions = {};
# TODO create a test parsing module if need be....
foreach my $tsc (@$ra_tests) {
    next unless -e $file_loc .'/' . $tsc .'.log';
    my $cmd_found = 0; 
    open (my $fh, $file_loc.'/'.$tsc.'.log');
    foreach my $line (<$fh>) {
        chomp $line;
        if ($cmd_found == 0 and $line =~ /getNewBrowserSession/) {
            $cmd_found = 1;
            next;
        } elsif ($cmd_found == 1) {
           # Got result  : OK,3301e1b807d34613b89687f0613d2d36
            $line =~ s/^Got result  : OK,//;
            unless ($rh_sessions->{$line}) {
              $rh_sessions->{$line} = [];
            }
            push @{$rh_sessions->{$line}}, $tsc;
            last;
        }
    }
    close $fh;
}
    print Dumper($rh_sessions);
