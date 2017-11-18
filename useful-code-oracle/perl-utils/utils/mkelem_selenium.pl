#!/usr/bin/perl 
use strict;
my @output = `ade lsprivate .`;
chomp(@output);
my @files_to_mkelem = grep { -e $_; } @output;
my $files = '';
foreach my $file (@files_to_mkelem) {
    next unless -e $file;
    my $cmd = "ade mkelem -nc -recursive $file";
    print $cmd, "\n";
    print `$cmd`;
}
