#!/usr/bin/env perl
use List::Util qw[min max];

use strict;
use warnings;
use Data::Dumper;

my $history_file = $ARGV[0];
my $ra_data = &process_data($history_file);
my $rh_iostats_summary = &get_iostats_summary($ra_data);
print Dumper($rh_iostats_summary);
my $ra_iostats = $rh_iostats_summary->{'iowait'};
for(my $i =0; $i< @$ra_iostats; $i++) {
    print $rh_iostats_summary->{'timestamp'}->[$i] . '= '. $$ra_iostats[$i], "\n";
}
print max(@{$rh_iostats_summary->{'iowait'}});

#print Dumper($ra_data);
sub process_data {
    my ($history_file) = @_;
    my $ra_data = [];
    open(my $fh, $history_file);
    my @content = <$fh>;
    chomp @content;
    close $fh;
    my $rh_snapshot = undef;
    my $date_found = 0;
    my $command = undef;
    foreach my $line (@content) {
        if ($line =~ /^DATE:\s+(.*)$/) {
            push @{$ra_data}, $rh_snapshot if $rh_snapshot;
            $rh_snapshot = {};
            $date_found = 1;
            $command = undef;
            $rh_snapshot->{'timestamp'} = $1;
        } 
        next unless $date_found;
        if ($line =~ /^LABEL\s+SERVER\s+TEST:\s+(.*)$/) {
            $rh_snapshot->{'label_server_test'} = $1;
            next;
        }
        if ($line =~ /^TOP\s+PROCESSORS\s+\((.*)\):/) {
            $command = 'top';
            $rh_snapshot->{$command}->{'command'} = $1;
            $rh_snapshot->{$command}->{'output'} = [];
            next;
        } elsif ($line =~ /^I\/O STATS\s+\((.*)\):/) {
            $command = 'iostats';
            $rh_snapshot->{$command}->{'command'} = $1;
            $rh_snapshot->{$command}->{'output'} = [];
            next;
        } elsif ($line =~ /^IPC\s+\((.*)\):/) {
            $command = 'ipc';
            $rh_snapshot->{$command}->{'command'} = $1;
            $rh_snapshot->{$command}->{'output'} = [];
            next;
        } elsif ($line =~ /^DISK\s+\((.*)\):/) {
            $command = 'disk';
            $rh_snapshot->{$command}->{'command'} = $1;
            $rh_snapshot->{$command}->{'output'} = [];
            next;
        } elsif ($line =~ /^=====/) {
            $date_found = 0;
            next;
        }
        if ($command) {
            push @{$rh_snapshot->{$command}->{'output'}}, $line;
        }
    }
    return $ra_data;
}

sub get_iostats_summary {
    my ($ra_data) = @_;
    my $rh_summary = {'tin' => 0, 'tout'=> 0, 'user' => 0, 'sys' => 0, 'idle'=> 0, 'iowait' => [], 'physc' => 0, 'entc' => 0 , 'timestamp' => []};
    foreach my $rh_snapshot (@$ra_data) {
      my $timestamp = $rh_snapshot->{'timestamp'};
        my $ra_output = $rh_snapshot->{'iostats'}->{'output'};
        my $flag = 0;
        foreach my $line (@$ra_output) {
            next unless $line;
            $line =~ s/^\s+//; $line =~ s/\s+$//;
            next unless $line;
            if ($line =~ /iowait/) {
                $flag = 1; next;
            }
            next unless $flag;
            $line =~ s/\s+/ /g;
            my ($tin, $tout, $user, $sys, $idle, $iowait, $physc, $entc) = split(/\s/, $line);
            print "TIM $tin";
            push @{$rh_summary->{'timestamp'}}, $timestamp;
            $rh_summary->{'tin'} += $tin;
            $rh_summary->{'tout'} += $tout;
            $rh_summary->{'user'} += $user;
            $rh_summary->{'sys'} += $sys;
            $rh_summary->{'idle'} += $idle;
            push @{$rh_summary->{'iowait'}}, $iowait;
            $rh_summary->{'physc'} += $physc;
            $rh_summary->{'entc'} += $entc;
        }
    }
    return $rh_summary;
}
