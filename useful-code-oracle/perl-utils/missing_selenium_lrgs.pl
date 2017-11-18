#!/usr/bin/env perl
use strict;
use warnings;

my $file2 = "/home/skgupta/list_em_selenium_regress.lrg";
my $file1 = "/home/skgupta/list_selenium_lrgs_121130.lrg";

my $rh_all_lrgs = &read_lrgs($file1);
my $rh_lrgs_in_suite = &read_lrgs($file2);
my $ra_missing_lrgs = &missing_lrgs($rh_all_lrgs, $rh_lrgs_in_suite);
print join ',', @$ra_missing_lrgs;

sub read_lrgs {
    my ($file) = @_;
    open (my $fh, $file) or die "Could not open $file : $!\n";
    my @content = <$fh>;
    chomp @content;
    close $fh;
    my @lrgs = ();
    foreach my $line (@content) {
        push @lrgs, split (',', $line);
    }
    my %lrgs = map {$_ => 1} @lrgs;
    return \%lrgs;
}

sub missing_lrgs {
    my ($rh_lrg1, $rh_lrg2) = @_;
    print "Count 1 " . (scalar keys %$rh_lrg1);
    print "\nCount 2 " . (scalar keys %$rh_lrg2), "\n";
    my @lrgs = ();
    my @lrgs_missing = grep { ! $rh_lrg2->{$_}; }keys %$rh_lrg1;
    return \@lrgs_missing;
}
