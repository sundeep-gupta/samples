#!/usr/bin/env perl
use strict;
use warnings;

my $result_loc = $ARGV[0];
die "$result_loc does not exist\n" unless -e $result_loc;

opendir(my $dh, $result_loc);
my @ls = readdir($dh);
closedir($dh);
my @ls_filtered = grep { $_ ne '.' and $_ ne '..' and -d "$result_loc/$_" and -e "$result_loc/$_/selenium_server.0.log"; } @ls;
my $rh_broken_pipe = {};
foreach my $dir (@ls_filtered) {
    opendir ($dh, "$result_loc/$dir");
    @ls = readdir ($dh);
    closedir($dh);
    my @ls_filtered_2 = grep { $_ =~ /^selenium_server\./ } @ls;
    foreach my $file (@ls_filtered_2) {
        # print "Checking for exception in $dir/$file ...";
        if (&check_brokenpipe("$result_loc/$dir/$file")) {
          #  print "Found!\n";
            $rh_broken_pipe->{"$result_loc/$dir/$file"} = 1;
        } else {
           # print "Not found!\n";
        }
    }
}
use Data::Dumper; print Dumper($rh_broken_pipe);
sub check_brokenpipe {
    my ($file) = @_;
    open(my $fh, $file) or do { print "Failed to open file $file : $!\n"; return; };
    my @content = <$fh>;
    close $fh;
    return grep {$_ =~ /SocketException/ or $_ =~ /Broken pipe/} @content;
}
