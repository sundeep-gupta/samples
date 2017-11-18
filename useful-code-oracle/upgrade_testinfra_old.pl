#!/usr/bin/env perl
use strict;
use warnings;
#
# Script to upgrade to testinfra 1.0.4 from testinfra 1.0.3



sub applyFix1843() {
    # Step 1 : Find all <lrg>.gradle in $REPO_ROOT/tests/suites
    my $ra_lrgs = &getLrgs();
    foreach my $lrgName (@$ra_lrgs) {
        if (&isValidLrgName($lrgName)) {
            print "lrg $lrgName is valid... skipping the changes for it.\n";
            next;
        }
        my $newLrgName = getNewLrgName($lrgName);
        print "Applying fix for : $lrgName as $newLrgName\n";
        next;
        renameLrgGradle($lrgName, $newLrgName);
        renameLrgTask($lrgName);
        renameLrgFolder($lrgName);
        renameLrgXml($lrgName);
    }
}

sub isValidLrgName {
    my ($lrgName) = @_;
    return $lrgName =~ /^em/;
}

sub getNewLrgName {
    my ($oldLrgName) = @_;
    do {
        print "***************************** Rules for LRG name ************************************\n";
        print "1. The lrg name must begin with 'em'.\n";
        print "2. The lrg name must be unique in the repository. \n";
        print "3. The lrg name preferebly must begin with repository name. Example 'emdi_sample1'\n";
        print "*************************************************************************************\n";

        print "Please enter the new lrg name for, $oldLrgName : ";
        my $newLrgName = <STDIN>;
        chomp $newLrgName;
        if (&isValidLrgName($newLrgName)) {
            return $newLrgName;
        }
        print "ERROR: $newLrgName is an invalid LRG name. Please see the rules below for lrg name."
    } while (1);
}

sub getLrgs {
    my $ra_lrgs = [];
    my @output = `gradle print_ALL_LRGS`;
    chomp @output;
    my $taskExecuted = 0;
    foreach my $line (@output) {
        $line =~ s/^\s+//; $line =~ s/\s+$//;
        if ($line =~ /:print_ALL_LRGS/) {
            $taskExecuted = 1;
            next;
        }
        if ($taskExecuted) {
            # An empty line means end of lrg list.
            unless ($line) {
                last;
            }
            push @$ra_lrgs, $line;
        }
    }
    return $ra_lrgs;
}

sub renameLrgGradle {
    my ($lrgName, $newLrgName) = @_;
    my $lrgFile = $ENV{'REPO_ROOT'} . "/tests/suites/$lrgName.gradle";
    my $newLrgFile = $ENV{'REPO_ROOT'} . "/tests/suites/$newLrgName.gradle";
    print "Checking if $lrgFile exist.\n";
    unless (-f $lrgFile) {
        print "STEP FAIL : $lrgFile does not exist.\n";
    }
    my $command = "git mv $lrgFile $newLrgFile";
    my @output = `$command`;
}

sub renameLrgTask {
    my ($lrgName, $newLrgName) = @_;
    # Since we renamed the file already, we need to open the new file 
    my $lrgFile = $ENV{'REPO_ROOT'} . "/tests/suites/$newLrgName.gradle";
    open (my $fh, ">$lrgFile") or do {
        die "Failed to open the file, $lrgFile : $!\n";
    };
    my @lines = <$fh>;
    foreach my $line(@lines) {
        $line =~ s/task\s+$lrgName/task $newLrgName/;
    }
    foreach my $line (@lines) {
        print $fh $line;
    }
    close $fh;
}

sub renameLrgFolder {
    my ($lrgName, $newLrgName) = @_ ;
    my $oldFolder = $ENV{'REPO_ROOT'} . "/tests/suites/$lrgName";
    unless (-e $oldFolder) {
        die "STEP FAIL: $oldFolder does not exist.\n";
    }
    my $newFolder = $ENV{'REPO_ROOT'} . "/tests/suites/$newLrgName";
    my $command = "git mv $oldFolder $newFolder";
    my $output = `$command`;
}

sub renameLrgXml {
    my ($lrgName, $newLrgName) = @_;
    my $lrgFolder = $ENV{'REPO_ROOT'} . "/tests/suites/$newLrgName";
    opendir(my $dh, $lrgFolder);
    my @files = readdir($dh);
    foreach my $entry (@files) {
        if ($entry =~ /^$lrgName-(.*)\.xml/) {
            my $newXml = "$newLrgName-$1.xml";
            my $command = "git mv $lrgFolder/$entry $lrgFolder/$newXml";
            my $output = `$command`;
        }
    }
    closedir $dh;
}

sub renameLrgInMetadata {
    my ($lrgName, $newLrgName) = @_;
    my $suitesXml = $ENV{'REPO_ROOT'} . "/tests/lrg_metadata/lrg_metadata.xml";
    unless (-e $suitesXml) {
        die "STEP FAIL: $suitesXml does not exist.\n";
    }
    open my $fh, $suitesXml or die "Failed to open $suitesXml\n";
    my @lines = <$fh>;
    foreach my $line (@lines) {
        $line = $line =~ s/$lrgName/$newLrgName/g;
    }
    print $fh @lines;
    close $fh;
}

sub main {
    my $ra_fixes = [
        '1427' => {
            'summary' => "Use GIT_VIEW_ROOT & T_WORK properties from DevInfraPlugin"
            'description' => 
            'apply' => $apply_fix_1427
        }
        '1532' => {
            'description' => "Generates the tests/suites/gradle.properties dynamically."
            'apply' => $apply_fix_1532
        }
        '843' => {
            'description' => "Avoid creating testng.xml per test block."
            'apply' => $apply_fix_843
        }
    ];
    foreach my $fix (keys %$rh_fixes) {
        print "Applying fix : $fix\n";
        &{$rh_fixes{$fix}->{'apply'}}()
    }
}

&main();
