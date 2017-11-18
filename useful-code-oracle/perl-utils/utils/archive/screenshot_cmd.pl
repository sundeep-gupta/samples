#!/usr/bin/env perl
use strict;
use Data::Dumper;
use File::Basename;
use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;
my $lrg_cnt = 0;
sub get_ss_timing {
    my ($dir, $lrg) = @_;
    my $path = $dir . '/'. $lrg;
    my $obj = SeleniumCmdParse->new($path) or return undef;
    my $rh_execution_time = $obj->get_screenshot_per_command();
    return $rh_execution_time;
}

my $lrg_dir = $ARGV[0];
opendir(my $dh, $lrg_dir);
my @lrgs = readdir($dh);
closedir($dh);
my $rh_lrgs = {};
foreach my $lrg (@lrgs) {
    next if $lrg =~ /^\.\.?$/;
    next unless -d "$lrg_dir/$lrg";
    next unless -e $lrg_dir.'/'.$lrg.'/selenium_cmd_timing.log';
    print $lrg, "\t";
    $lrg_cnt++;
    my $retval = &get_ss_timing($lrg_dir, $lrg);
    $rh_lrgs->{$lrg} = $retval if $retval;
}
print Dumper($rh_lrgs);
my $rh_total = {};
foreach my $lrg (keys %$rh_lrgs) {
    my $rh_lrg = $rh_lrgs->{$lrg};
    foreach my $cmd (keys %$rh_lrg) {
        $rh_total->{$cmd} = {'cnt'=>0, 'w_ss_time'=>0,'cmd_time'=>0} unless $rh_total->{$cmd};
        $rh_total->{$cmd}->{'cnt'} = $rh_total->{$cmd}->{'cnt'} + $rh_lrg->{$cmd}->{'cnt'};
        $rh_total->{$cmd}->{'w_ss_time'} = $rh_total->{$cmd}->{'w_ss_time'} + $rh_lrg->{$cmd}->{'w_ss_time'};
        $rh_total->{$cmd}->{'cmd_time'} = $rh_total->{$cmd}->{'cmd_time'} + $rh_lrg->{$cmd}->{'cmd_time'};
    }
}
print Dumper($rh_total);
print "Total LRGs considered : ". $lrg_cnt."\n";
