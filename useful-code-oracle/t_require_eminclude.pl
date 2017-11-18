#!/usr/bin/env perl
use strict;
use warnings;
my @line = (
    'require EMInclude.pm;',
    'require $emnclude;',
    'require "/usr/bin/EMInclude.pm";',
);
    my $regex_xpath  = '^\s*require\s(.*?;)';
foreach my $line (@line) {
    if ($line =~ /$regex_xpath/) {
        unless ($1) {
            print "MATCH $line\n";
        }
        else {
        print "MATCH $line : $1\n";
        }
    }
    else {
        print "NOT MATCH $line\n";
    }

}
