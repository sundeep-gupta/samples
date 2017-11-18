#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
use lib $ENV{'HOME'}.'/utils';
use SeleniumBrowserLogParser;

my $farm_job_loc = $ARGV[0];
opendir(my $dh, $farm_job_loc);
my @lrgs = readdir($dh);
closedir($dh);
foreach my $lrg (@lrgs) {
    next if $lrg =~ /^\.\.?$/;
    next unless -d "$farm_job_loc/$lrg";

    print "Checking LRG $lrg... ";
    unless (-e "$farm_job_loc/$lrg/selenium_browser.log") {
        print "No selenium_browser.log\n";
        next;
    }
    my $parser = SeleniumBrowserLogParser->new("$farm_job_loc/$lrg");
    my $ra_testnames = $parser->get_testnames();
    my $last_test = $ra_testnames->[scalar(@$ra_testnames) -1 ];
    if (-e "$farm_job_loc/$lrg/$last_test.dif") {
      print "ERROR $last_test difd";
    }
    #print Dumper($ra_testnames);
    if (scalar(grep{$_ =~ /^none$/} @$ra_testnames) > 1) {
        print "found firefox restart.\n";
    } else {
        print "No firefox restart.\n";
    }
}
