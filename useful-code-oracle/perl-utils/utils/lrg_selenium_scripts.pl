#!/usr/bin/env perl
use strict;
use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;
use SeleniumUpgradeHelper;
use File::Basename qw/basename/;
use Data::Dumper;
my $path = $ARGV[0];
my $lrg = &File::Basename::basename($path);

my $obj = SeleniumCmdParse->new($path) or die "Could not create SeleniumCmdParse instance.";
my $rh_time = $obj->get_test_execution_times();
&emfind($rh_time);
foreach my $test (keys %$rh_time) {
    my $r_val = $rh_time->{$test};
    if (ref($r_val) eq 'ARRAY') {
        foreach my $val (@$r_val) {
            print `ade co -nc $ENV{'ADE_VIEW_ROOT'}/$val`;
            &replace_www_selenium($ENV{'ADE_VIEW_ROOT'}."/$val");
        }
    } else {
      print `ade co -nc $ENV{'ADE_VIEW_ROOT'}/$r_val`;
            &replace_www_selenium($ENV{'ADE_VIEW_ROOT'}."/$r_val");
    }
}
