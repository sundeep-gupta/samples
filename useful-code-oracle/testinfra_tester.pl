#!/usr/bin/env perl
#
use warnings;
use strict;

if (!$ENV{'GRADLE_USER_HOME'}) {
    print "Environment variable GRADLE_USER_HOME is not defined.\n";
    $ENV{'GRADLE_USER_HOME'} = '/ade_autofs/ade_infra/GRADLE_1.11_GENERIC.rdd/LATEST/gradle';
    print "GRADLE_USER_HOME = " . $ENV{'GRADLE_USER_HOME'};
    $ENV{'PATH'} = $ENV{'GRADLE_USER_HOME'} . '/bin;' . $ENV{'PATH'};
}

my $BUILD_GRADLE = $ENV{'ADE_VIEW_ROOT'}.'/emgc/build.gradle';

my $usage = sub {
    my ($message) = @_;

    print "$message\n";
    exit(1);
};
my $parse_args = sub {
    my (@args) = @_;
    unless (scalar @args) {
        &$usage("LRG Name is required.");
    }
    
    my $rh_options = {
        'lrgname' => shift @args,
        'options' => [],
    };
    if (scalar @args) {
        $rh_options->{'options'} = [@args];
    }
    return $rh_options;
};


my $execute = sub {
    my ($rh_options) = @_;
    my $cmd = "gradle -b $BUILD_GRADLE do_lrg -Plrgs=" . $rh_options->{'lrgname'};
    my $options = join(' ', @{$rh_options->{'options'}});
    print "Running: $cmd $options\n";
    my @output = `$cmd $options`;
    my $outputFile = $ENV{'T_WORK'} . '/testinfra_tester.out';
    open(my $fh, ">$outputFile") or do {
        print "Could not open $outputFile for writing gradle command output.";
        return;
    };
    print $fh join('', @output);
    close $fh or do {
        print "Failed to close the handle for file $outputFile.";
        return;
    };
};

sub main() {
    my (@args) = @_;
    my $rh_options = &$parse_args(@args);
    &$execute($rh_options);
}

&main(@ARGV);
