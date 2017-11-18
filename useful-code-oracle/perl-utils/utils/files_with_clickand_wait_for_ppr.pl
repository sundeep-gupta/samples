#!/usr/bin/env perl

use strict;
my $file = $ARGV[0];
die "$file does not exists" unless -e $file;
open(my $fh, $file);
my @lines = <$fh>;
close($fh);
chomp @lines;
my @files = ();
foreach my $line (@lines) {
    $line =~ s/(\d+)\.//;
    $line =~ s/^\s+//; $line =~ s/\s+$//;
    print $line,"\n";
    next unless $line ne '';
    my $file = $ENV{'ADE_VIEW_ROOT'}.'/'. $line;
    next unless -e $file;
    next if -d $file;
    open(my $fh, $file);
    my @content = <$fh>;
    close($fh);
    if (grep {$_ =~ /WaitForPPR/;} @content) {
        push @files, $file;
    }

}
use Data::Dumper;
print Dumper(\@files);
