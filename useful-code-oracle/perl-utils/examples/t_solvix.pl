#!/usr/bin/env perl
use strict;
use warnings;


sub __get_browser_path {
    my ($browserType, $ra_firefox_loc) = @_;
    unless ($browserType) {
        print "browserType is not set correctly!\n";
        return;
    }
    my $rh_versions = &__get_versions($ra_firefox_loc);
    my $browserPath = '';
    # if we want firefox 2 and have firefox 2 then use it; otherwise set browsertype to firefox 3
    if (scalar(@{$rh_versions->{$browserType}})){
        $browserPath = $rh_versions->{$browserType}->[0];
    }
    elsif ($browserType eq 'firefox2' and scalar(@{$rh_versions->{'firefox3'}})) {
        $ENV{'SELENIUM_BROWSER_TYPE'} = 'firefox3';
        $browserPath = $rh_versions->{'firefox3'}->[0];
    }
    print "Browser path is $browserPath";
    return $browserPath;
}

sub __get_versions {
    my ($ra_firefox_loc) = @_;
    my $rh_firefox_versions = {'firefox2' => [], 'firefox3' => []};
    for my $loc (@$ra_firefox_loc) {
        next unless -e $loc;
        print "Finding version for $loc.";
        my $version = `$loc -version`;
        print $version;
        if ($version =~ /Mozilla Firefox 2/) {
            print "Adding $loc to firefox2 queue.";
            push @{$rh_firefox_versions->{'firefox2'}}, $loc;
        } elsif ($version =~ /Mozilla Firefox 3\.(\d+)/) {
            if ($1 <= 5) {
                print "Adding $loc to firefox3 queue.";
                push @{$rh_firefox_versions->{'firefox3'}}, $loc;
            } else {
                print "Ignoring the incompatible firefox browser, $loc";
            }
        }
    }
    return $rh_firefox_versions;   
}

&__get_browser_path('firefox2',['/usr/local/bin/firefox', '/usr/bin/firefox', '/usr/local/packages/firefox_remote/2.0.0.20/firefox']);
