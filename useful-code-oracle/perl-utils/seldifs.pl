#!/usr/bin/env perl
use Data::Dumper;
use strict;
use warnings;
my $debug = 0;
my $result_loc = $ARGV[0];
die "$result_loc does not exist\n" unless -e $result_loc;
my @ls_filtered = &get_lrgs_running_new_framework($result_loc);
my @sh_lrgs = grep {$_ =~ /enk/} @ls_filtered;

foreach my $dir (@sh_lrgs) {
    my $ra_difs = &get_all_dif("$result_loc/$dir");
    my $ra_seldifs = &filter_selenium_difs("$result_loc/$dir", $ra_difs);
    print Dumper($ra_seldifs);
}
sub filter_selenium_difs {
    my ($result_loc, $ra_difs) = @_;
    my $ra_seldifs = [];
    foreach my $dif (@$ra_difs) {
        my $logfile = "$result_loc/$dif.log";
        if (-e "$result_loc/$dif.log" ) {
            open(my $fh, $logfile);
            my @contents = <$fh>;
            close $fh;
            if (grep {$_ =~ /Send command/} @contents) {
                push @$ra_seldifs, $logfile;
            }
        }
    }
    return $ra_seldifs;
}
sub get_all_dif {
    my ($loc) = @_;
    my $ra_difs = [];
    opendir(my $dh, $loc);
    my @difs = grep {$_ =~ /\.dif$/;} readdir($dh);
    closedir($dh);
    foreach my $dif (@difs) {
        $dif =~ s/\.dif$//;
        push @$ra_difs, $dif;
    }
    return $ra_difs;
}

sub get_lrgs_running_new_framework {
    my ($result_loc) = @_;
    opendir(my $dh, $result_loc);
    my @ls = readdir($dh);
    closedir($dh);
    my @ls_filtered = grep { $_ ne '.' and $_ ne '..' and -d "$result_loc/$_" and -e "$result_loc/$_/selenium_server.0.log"; } @ls;
    return @ls_filtered;
}
