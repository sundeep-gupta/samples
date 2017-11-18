#!/usr/bin/env perl
use strict;
use Data::Dumper;

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

my $parse_old_selchk = sub {
    my ($file) = @_;
    open (my $fh, $file);
    my @content = <$fh>;
    close $fh;
    chomp @content;
    my @files = grep { $_ =~ /^\s+\/ade\/aime/; } @content;
    foreach my $file (@files) {
        my @tokens = split (/\|/, $file);
        $file = $tokens[0];
        $file =~ s/^\s+//; $file =~ s/\s+$//;
        $file =~ s/^\/ade\/.*?\///;
        $file =~ s/^oracle\///;
    }
    my %parsed_files = map { $_ => 1; } @files;
    return \%parsed_files;
};

my $parse_new_selchk = sub {
    my ($file) = @_;
    open (my $fh, $file);
    my @content = <$fh>;
    close $fh;
    chomp @content;
    my @files = grep { $_ =~ /^FILE:/; } @content;
    foreach my $file (@files) {
        $file =~ s/^FILE:\s+//;
        $file =~ s/^\/ade\/.*?\///;
        $file =~ s/^oracle\///;
    }
    my %parsed_files = map { $_ => 1} @files;
    return \%parsed_files;
};

my $compare = sub {
    my ($rh_old_files, $rh_new_files) = @_;
    my @missed_files = grep { not $rh_new_files->{$_} } keys %$rh_old_files;
    my @new_files    = grep { not $rh_old_files->{$_} } keys %$rh_new_files;
    return (\@new_files, \@missed_files);
};


sub main {
    my $rh_old_files = &$parse_old_selchk($file1);
   # print Dumper($rh_old_files);
    my $rh_new_files = &$parse_new_selchk($file2);
    my ($ra_new_files, $ra_missed_files) = &$compare($rh_old_files, $rh_new_files);
    printf("Total number of files scanned : %s\n", scalar keys %$rh_old_files);
    printf("Total number of files scanned : %s\n", scalar keys %$rh_new_files);
    print "Files which are not tested with modified selcheck utility. ". (scalar @$ra_missed_files) . "\n";
    print "-" x 100, "\n";
    foreach my $file (@$ra_missed_files) {
        print $file, "\n";
    }
    print "\nFiles which are newly tested with modified selcheck utility. ". (scalar @$ra_new_files) . "\n";
    print "-" x 100, "\n";
    foreach my $file (@$ra_new_files) {
        print $file, "\n";
    }
}

main();

