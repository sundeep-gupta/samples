#!/usr/bin/env perl
use strict;
use Data::Dumper;
use File::Basename;
use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;
my $lrg_cnt = 0;
sub get_login_time {
    my ($dir, $lrg) = @_;
    my $path = $dir . '/'. $lrg;
    my $obj = SeleniumCmdParse->new($path) or return undef;
    my $rh_execution_time = $obj->get_login_time();
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
    $lrg_cnt++;
    my $retval = &get_login_time($lrg_dir, $lrg);
    $rh_lrgs->{$lrg} = $retval if $retval;
}
print Dumper($rh_lrgs);
print "Calculating average...\n";
my $rh_total = { 'login_cnt' => 0, 'login_time' => 0 , 'logout_cnt' => 0, 'logout_time' => 0};
foreach my $lrg (keys %$rh_lrgs) {
    my $rh_lrg = $rh_lrgs->{$lrg};
    foreach my $test (keys %$rh_lrg) {
        if ($rh_lrg->{$test}->{'login'}) {
            $rh_total->{'login_cnt'}++;
            $rh_total->{'login_time'} += $rh_lrg->{$test}->{'login'};
        }
        if ($rh_lrg->{$test}->{'logout'}) {
            $rh_total->{'logout_cnt'}++;
            $rh_total->{'logout_time'} += $rh_lrg->{$test}->{'logout'};
        }
    }
}
$rh_total->{'login_avg'} = $rh_total->{'login_time'} / $rh_total->{'login_cnt'};
$rh_total->{'logout_avg'} = $rh_total->{'logout_time'} / $rh_total->{'logout_cnt'};
print Dumper($rh_total);

