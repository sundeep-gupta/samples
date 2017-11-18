#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
open (my $fh, $ARGV[0]);
my @contents = <$fh>;
close $fh;
my $rh_contents = {};
foreach my $line (@contents) {
    next unless $line =~ /Line\scontent\sis/;
    if ($line =~ /T_SYSTEM:(\w+\s)/) {
        $rh_contents->{$1} = 1;
    }
}
foreach my $command (keys %$rh_contents) {
  $command =~ s/\s+$//; $command =~ s/^\s+//;
    my @output = `which $command 2>&1`;
    chomp @output;
    if ($output[0] and $output[0] !~ /Command\snot\sfound/ and $output[0] !~ /no\s$command\sin/) {
        print $command," ";
# $output[0], "\n";
    }
 #   else {
#        print $command, "NOT FOUND\n";
#    }
}
#local $"=' ';
#print keys %$rh_contents;
