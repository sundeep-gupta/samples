#!/usr/bin/perl 
my $out = `uname -a`;
if ($out =~ /x86_64/) {
    print "7343";
}
