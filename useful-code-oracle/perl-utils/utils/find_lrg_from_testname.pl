#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
my $get_testnames = sub {
    my $testname_file = '/home/skgupta/pollforfiles.lst';
    open (my $fh, $testname_file);
    my @files_list = <$fh>;
    close $fh;
    chomp @files_list;
    my $rh_files = { map { $_ => {}; } @files_list };
    foreach my $file (keys %$rh_files) {
        if ($file =~ /.*\/(.+)\.pl$/) {
           $rh_files->{$file}->{'testname'} = $1;
        }
    }
    return $rh_files;
};
my $get_lrg_result_loc = sub {
    my ($label_result_loc) = @_;
    unless (-d $label_result_loc) {
        print "ERROR: $label_result_loc is not a directory.\n";
        exit(1);
    }
    opendir(my $dh, $label_result_loc);
    my @ls = readdir $dh;
    closedir $dh;
    my $ra_lrg_list = [];
    foreach my $item (@ls) {
        next unless -d "$label_result_loc/$item";
        next if $item eq '.' or $item eq '..';
        push @$ra_lrg_list, $item;
    }
    return $ra_lrg_list;
};
sub main {
    my (@args) = @_;
    my $label_result_loc = $args[0];
    my $ra_lrg_list = &$get_lrg_result_loc($label_result_loc);
    my $rh_files = &$get_testnames();
    my $rh_lrgs = {};
    foreach my $file (keys %$rh_files) {
        my $testname = $rh_files->{$file}->{'testname'};
        foreach my $lrg (@$ra_lrg_list) {
            my $path = "$label_result_loc/$lrg/$testname.log";
            if (-e $path) {
                print "$lrg\n";
                $rh_lrgs->{$lrg} = 1;
                last;
            }
        }
    }
    print Dumper($rh_lrgs);
}


&main(@ARGV);
