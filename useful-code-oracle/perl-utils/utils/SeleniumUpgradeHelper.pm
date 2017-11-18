#!/usr/bin/env perl
use strict;
package SeleniumUpgradeHelper;

our @ISA = ('Exporter');
our @EXPORT = qw/replace_www_selenium emfind/;
sub replace_www_selenium {
    my ($file) = @_;
    my $search = 'WWW::Selenium';
    my $replace = 'Oracle::EM::Selenium';
    return unless -e $file;

    open(my $fh, $file);
    my @data = <$fh>;
    close($fh);
    foreach my $line (@data) {
        if ($line =~ /$search/) {
            $line =~ s/$search/$replace/g;
        }
    }
    open(my $fh, ">$file");
    print $fh @data;
    close $fh;
}

sub emfind {
    my ($rh_tests) = @_;
    foreach my $test (keys %$rh_tests) {
        my @files = `emfind $test.pl`;
        chomp @files;
        if (scalar (@files) == 1) {
            $rh_tests->{$test} = $files[0];
        } else {
            $rh_tests->{$test} = [@files] ;
        }
    }
}
1;
