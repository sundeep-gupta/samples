#!/usr/bin/env perl

use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;
use File::Basename qw/dirname/;
my $lrg_loc = $ARGV[0];
$lrg_loc = dirname($lrg_loc) if -f $lrg_loc;
my $sel_cmd_parse = SeleniumCmdParse->new($lrg_loc);
exit 1 unless $sel_cmd_parse;
#my $rh_tests = $sel_cmd_parse->get_delayed_tests(600);
my $rh_time_taking_tests = $sel_cmd_parse->find_time_taking_command(600);
local $" = " ";
foreach my $test(keys %$rh_time_taking_tests) {
    print $test,"\n", "-" x 120, "\n";
    foreach my $raw ( @{$rh_time_taking_tests->{$test}}) {
        print "@$raw";
        print "\n";
    }
}

