#!/usr/bin/env perl

use strict;
use lib $ENV{'HOME'}.'/utils';
use Data::Dumper;
use SeleniumCmdParse;
use File::Find;
my $label_path = $ARGV[0];
my $rh_stats = {};
opendir(my $dh, $label_path);
my @lrgs = readdir($dh);
closedir($dh);
foreach my $lrg (@lrgs) {
    next if $lrg =~/^\.+$/;
    next unless -e $label_path . '/' . $lrg . '/selenium_tester.log';
    print "$lrg\n";
    $rh_stats->{$lrg} = &get_save_html_time($label_path.'/'.$lrg);
}
my $sum = 0;
my $cnt = 0;
foreach my $lrg (keys %$rh_stats) {
    my $ra_lrg = $rh_stats->{$lrg};
    foreach my $elem (@$ra_lrg) {
        $sum += $elem->{'time'};
        $cnt++;
    }
}

#my $lrg_path = $ARGV[0];
#die "$lrg_path not found" unless -e $lrg_path.'/selenium_tester.log';
#my $ra_result = &get_save_html_time($lrg_path);
#my $sum = 0;
#foreach my $elem (@$ra_result) {
#    $sum += $elem->{'time'};
#}
print "Total time taken : " . $sum, "\n";
print "Total html captures : $cnt\n";

sub get_save_html_time {
    my ($lrg_path) = @_;
    open(my $fh, $lrg_path.'/selenium_tester.log');
    my @lines = <$fh>;
    chomp @lines;
    close($fh);
    my $start_time = undef;
    my $ra_times = [];
    foreach my $line (@lines) {
        if (($line =~ /Sending command:/) and ($line =~ /saveHtmlSource/)) {
            $start_time = $line;
            $start_time =~ s/^\[(.*?)\].*/$1/;
        }elsif ($start_time and $line =~ /Received response:/) {
            $line =~ s/^\[(.*?)\].*/$1/;
            push @$ra_times, {'start' => $start_time, 'end' => $line, 'time' => &SeleniumCmdParse::date_diff2($start_time, $line)};
            $start_time = undef;
        }
    }
    return $ra_times;
}


