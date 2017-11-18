#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
sub get_lrg_areas {
    my ($rh_selenium_suites) = @_;
    my $file = "union1.csv";
    open (my $fh, $file);
    my @content = <$fh>;
    chomp @content;
    close $fh;
    my $rh_suites = {};
    my $match = 0;
    foreach my $line (@content) {
        my ($lrg, $owner, $area) = (split(',', $line))[0,1,3];
        $lrg =~ s/^\s+//; $lrg =~ s/\s+$//;
        $area =~ s/^\s+//; $area =~ s/\s+$//;
        next unless $lrg or $area;
        next unless $rh_selenium_suites->{$lrg};
        $rh_suites->{$area} = [] unless $rh_suites->{$area};
        push @{$rh_suites->{$area}}, $lrg;
        $match++;
    }
    print "Total suites matched with area name are " . $match, "\n";
    return $rh_suites;
}

sub get_selenium_suites {

    my $file = "selenium_lrgs_121217.lrgs";

    open (my $fh, $file);
    my @content = <$fh>;
    chomp @content;
    close $fh;
    my @lrgs = ();
    foreach my $line(@content) {
       push @lrgs, split (/,/, $line);
    }
    my %selenium_lrgs = map { $_ => 1; } @lrgs;
    return \%selenium_lrgs;
}
sub main {
    my $rh_selenium_suites = get_selenium_suites();
    print "Total number of selenium LRGs : ", scalar(keys(%$rh_selenium_suites)), "\n";
    my $rh_suites_actual = get_lrg_areas($rh_selenium_suites);
    print "Total areas are ", scalar(keys (%$rh_suites_actual)), "\n";
    my $rh_suites = {%$rh_suites_actual};
    
    my $ra_selenium_50 = get_distro_suites($rh_suites, 50);
    my $ra_selenium_100 = get_distro_suites($rh_suites, 100);
    my $ra_selenium_200 = get_distro_suites($rh_suites, 200);
    my $ra_selenium_remaining = get_distro_suites($rh_suites);
    print "First 50 LRGs are: \n", join (' ', @$ra_selenium_50),"\n";
    print "Next 100 LRGs are: \n", join (' ', @$ra_selenium_100),"\n";
    print "Next 200 LRGs are: \n", join (' ', @$ra_selenium_200),"\n";
    print "Remaining LRGs are: \n", join (' ', @$ra_selenium_remaining),"\n";
    
}

sub get_distro_suites {
    my ($rh_suites, $max) = @_;
    my $ra_selenium_suites = [];
    unless($max) {
        foreach my $area ( keys %$rh_suites ) {
            push @$ra_selenium_suites, @{$rh_suites->{$area}};
            delete $rh_suites->{$area};
        }
        return $ra_selenium_suites;
    }
    while ( scalar(@$ra_selenium_suites) < $max) {
        foreach my $area ( keys %$rh_suites ) {
            next unless scalar @{$rh_suites->{$area}};
            push @$ra_selenium_suites, shift(@{$rh_suites->{$area}})
        }
    }
    return $ra_selenium_suites;
}
main;
