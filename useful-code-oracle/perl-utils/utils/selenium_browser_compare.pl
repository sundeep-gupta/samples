#!/usr/bin/env perl
use strict;
use File::Basename;
use Data::Dumper;
scalar @ARGV >= 2 or die "There must be only 2 arguments which are selenium_browser files to compare\n";
my ($file1, $file2, $test, $command, $index) = @ARGV;

($file1 and -e $file1) or "$file1 does not exist.\n";
($file2 and -e $file2) or "$file2 does not exist.\n";

( &File::Basename::basename($file1) eq 'selenium_browser.log' and &File::Basename::basename($file2) eq 'selenium_browser.log' ) 
        or die "This script parses only selenium_browser.log";

my $rh_file1_lines = &parse_selenium_browser($file1, $test, $command);
my $rh_file2_lines = &parse_selenium_browser($file2, $test, $command);
print Dumper($rh_file1_lines);
print Dumper($rh_file2_lines);
print Dumper($rh_file1_lines->{$test}->[0]);
print Dumper($rh_file2_lines->{$test}->[0]);
$index = 0 unless $index;
# print Dumper([$rh_file1_lines->{$test}->[$index], $rh_file2_lines->{$test}->[$index]]);
#compare_selenium_browser_log($rh_file1_lines->{$test}->[$index]->{$command}, $rh_file2_lines->{$test}->[$index]->{$command});

sub compare_selenium_browser_log {
    my ($ra_one, $ra_two) = @_;
    print "Lengths differ" if scalar @$ra_one != scalar @$ra_two;
    
}

sub parse_selenium_browser {
    my ($file, $test, $command) = @_;
    my $rh_lines = {'lines' => []};
    open(my $fh, $file) or return undef;
    my @lines = <$fh>;
    if ($test) {
        $command = '' unless $command;
        my @test_lines = grep { $_ =~ /^\[.*?\]\[$test\s$command/;} @lines;
        @lines = @test_lines;
    }
    my $current_test = undef;
    my $current_cmd = undef;
    my $rh_cmd_log = undef;
    foreach my $line (@lines) {
        chomp $line;
        # Remove the timestamp;
        $line =~ s/^\[.*?\]//;
        push @{$rh_lines->{'lines'}}, $line;
        # TODO : Perform testcase specific parsing.
        $line =~ s/^\[.*?\]//;
        # Fetch tsc and command name :
        if ( $line =~ /TEST_NAME\s:\s(.*?)\sCOMMAND_NAME:\s(.*?)\s/) {
            if($current_test) {
               $rh_lines->{$current_test} = [] unless ($rh_lines->{$current_test});
               push @{$rh_lines->{$current_test}}, $rh_cmd_log;
            }
            $current_test = $1;
            $current_cmd = $2;
            $rh_cmd_log = {$current_cmd => []};
        }
        push @{$rh_cmd_log->{$current_cmd}}, $line;
    }
    close($fh);
    return $rh_lines;
}
