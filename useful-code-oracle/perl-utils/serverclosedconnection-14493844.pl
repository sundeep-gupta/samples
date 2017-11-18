#!/usr/bin/env perl
use strict;
use warnings;
use lib $ENV{'HOME'}.'/utils';

my $debug = 1;
my $result_loc = $ARGV[0];
die "$result_loc does not exist\n" unless -e $result_loc;
my @ls_filtered = &get_lrgs_running_new_framework($result_loc);

my $rh_issue = {};
my $issue = '"Server closed Connection"';
foreach my $dir (@ls_filtered) {
    opendir (my $dh, "$result_loc/$dir");
    my @ls = readdir ($dh);
    closedir($dh);
    my @ls_filtered_2 = grep { $_ =~ /\.log$/ } @ls;
    foreach my $file (@ls_filtered_2) {
        print "Checking for $issue in $dir/$file ..." if $debug;
        if (&check_issue("$result_loc/$dir/$file")) {
            print "Found!\n" if $debug;
            $rh_issue->{"$result_loc/$dir/$file"} = 1;
        } else {
            print "Not found!\n" if $debug;
        }
    }
}
use Data::Dumper; print Dumper($rh_issue);

sub check_issue {
    my ($file) = @_;
    open(my $fh, $file) or do { print "Failed to open file $file : $!\n" ; return; };
    my @content = <$fh>;
    close $fh;
    return grep {$_ =~ /Server closed connection without sending any data back/} @content;

}


sub get_lrgs_running_new_framework {
    my ($result_loc) = @_;
    opendir(my $dh, $result_loc);
    my @ls = readdir($dh);
    closedir($dh);
    my @ls_filtered = grep { $_ ne '.' and $_ ne '..' and -d "$result_loc/$_" and -e "$result_loc/$_/selenium_server.0.log"; } @ls;
    return @ls_filtered;
}
