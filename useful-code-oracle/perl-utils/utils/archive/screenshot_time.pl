#!/usr/bin/env perl
use strict;
use Data::Dumper;
use File::Basename;
use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;
my $lrg_cnt = 0;
sub get_ss_timing {
    my ($dir, $lrg, $test) = @_;
    my $path = $dir . '/'. $lrg;
    my $obj = SeleniumCmdParse->new($path) or return undef;
    if ($test) {
        print "Time taken by $path is " . Dumper($obj->get_screenshot_delay($test)), "\n";
    } else {
    my $rh_execution_time = $obj->get_screenshot_delay();
    my $total = 0;
    my $cmd_total = 0;
    my $cmd_ss_total =0;
    foreach my $test (keys %$rh_execution_time) {
        $total = $total + $rh_execution_time->{$test}->{'exec_time'};
        $cmd_total = $cmd_total + $rh_execution_time->{$test}->{'command'};
        $cmd_ss_total = $cmd_ss_total + $rh_execution_time->{$test}->{'command_with_screenshot'};
    }
    $lrg_cnt++;
    return {'total' => $cmd_total, 'cmd_ss' => $cmd_ss_total, 'ss_delay' => $cmd_ss_total - $cmd_total };
    }
}

my $lrg_dir = $ARGV[0];
print $lrg_dir;
opendir(my $dh, $lrg_dir);
my @lrgs = readdir($dh);
closedir($dh);
my $rh_lrgs = {};
foreach my $lrg (@lrgs) {
    next if $lrg =~ /^\.\.?$/;
    next unless -d "$lrg_dir/$lrg";
    print $lrg, "\n" if $lrg =~ /^\./;
    my $retval = &get_ss_timing($lrg_dir, $lrg);
    $rh_lrgs->{$lrg} = $retval if $retval;
}
print Dumper($rh_lrgs);
my $total_cmd_ss = 0; my $total_ss_delay = 0; my $total = 0;
foreach my $lrg (keys %$rh_lrgs) {
    $total = $total + $rh_lrgs->{$lrg}->{'total'};
    $total_cmd_ss = $total_cmd_ss + $rh_lrgs->{$lrg}->{'cmd_ss'};
    $total_ss_delay = $total_ss_delay +  $rh_lrgs->{$lrg}->{'ss_delay'};
}
print "Number of LRGs considered. " . $lrg_cnt, "\n";
print "Command+Screenshot : $total_cmd_ss \n";
print "Screenshot         : $total_ss_delay\n";
print "% delay : " . $total_ss_delay / $total_cmd_ss . "\n";
print "% delay : " . $total_ss_delay / $total . "\n";
