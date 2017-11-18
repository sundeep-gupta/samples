#!/usr/bin/env perl
use strict;
use lib $ENV{'HOME'}.'/utils';
use SeleniumCmdParse;

my $label_dir = $ARGV[0];
opendir(my $dh, $label_dir);
my @dirs = readdir($dh);
closedir($dh);
my $total_zip_space = 0;
my $lrg_cnt = 0;
foreach my $lrg (@dirs) {
    next if $lrg =~ /^\.\.?$/;
    next unless -e "$label_dir/$lrg/selenium_cmd_timing.log";
    $lrg_cnt++;
    $total_zip_space = &compute_selenium_ss_space($label_dir.'/'.$lrg) + $total_zip_space;
}
print $lrg_cnt,"\n";
print $total_zip_space, "\n";

sub compute_selenium_ss_space {
    my ($lrg_path) = @_;
    my $obj = SeleniumCmdParse->new($lrg_path);
    my $ra_testnames = $obj->get_tests();
    my $lrg_size = 0;
    foreach my $test (@$ra_testnames) {
        $lrg_size = $lrg_size + (-s $lrg_path.'/'.$test.'.zip') if -e $lrg_path . '/' . $test . '.zip';
    }
    print "$lrg_path : $lrg_size\n";
    return $lrg_size;
}
