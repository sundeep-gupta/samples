#!/usr/bin/env perl

my $file = $ARGV[0];
open(my $fh, "$file");
my @list = <$fh>;
chomp @list;
close $fh;
foreach my $file (@list) {
    $file =~ s/^\s+//; $file =~ s/\s+$//;
    next if -d $file;
    if (-e $file) {
        print `ade mkelem -recursive -nc $file`;
    }

}
