#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename qw/dirname/;
use lib  dirname($0);
use TestInfra::Logger;
use TestInfra::Utils;
use TestInfra::Fix1427;
use TestInfra::Fix1532;
use TestInfra::Fix672;
use TestInfra::Fix705;

my $usage = sub {
    my ($error) = @_;
    if ($error) {
        print "ERROR: $error\n";
    }
    my $usage = <<'USAGE';
Usage: $0 <location_of_your_repository>
USAGE

    print $usage;
    exit(0);
};

my $parse_args = sub {
    my (@args) = @_;
    my $rh_options = {};
    if (!@args or $args[0] eq '--help') {
        &$usage("No argument specified.");
    }
    unless (-d $args[0]) {
        &$usage("Invalid location, ". $args[0] . " specified for cutover.");
    }
    my $repoRootDir = $args[0];
    unless (-d "$repoRootDir/tests/suites") {
        &$usage("$repoRootDir/tests/suites directory does not exist.");
    }
    unless (-e "$repoRootDir/tests/lrg_metadata/lrg_metadata.xml") {
        &$usage("LRG metadata file, $repoRootDir/tests/lrg_metadata/lrg_metadata.xml, does not exist.");
    }
    $rh_options->{'repo_root'} = $repoRootDir;
    $rh_options->{'suites_dir'} = "$repoRootDir/tests/suites";
    $rh_options->{'lrg_metadata_file'} = "$repoRootDir/tests/lrg_metadata/lrg_metadata.xml";
    return $rh_options;
};

sub print_warning {
    my ($self) = @_;
    print <<'WARNING';

**********************************************************************************************
* This script makes changes to the files in your repository. The changes are                 *
* made assuming your gradle scripts are written in accordance with the                       *
* confluence page :                                                                          *
* https://confluence.oraclecorp.com/confluence/display/EMQA/How+to+create+LRG+in+EMaaS       *
* https://confluence.oraclecorp.com/confluence/display/EMQA/How+to+build+testcode+in+EMaaS   *
*                                                                                            *
* After running the script please validate the changes against the list of                   *
* changes suggested in 'Action Required' section of the release announcement                 *
* or with the confluence page :                                                              *
* https://confluence.oraclecorp.com/confluence/display/EMQA/How+to+create+LRG+in+EMaaS       *
* https://confluence.oraclecorp.com/confluence/display/EMQA/How+to+build+testcode+in+EMaaS   *
*                                                                                            *
*                                                                                            *
* The script generates a log file at \$HOME/upgrade_testinfra.log;                           *
**********************************************************************************************
Do you want to continue [Y/N]?

WARNING
    while (<>) {
        chomp $_;
        if ($_ eq 'y' or $_ eq 'Y') {
            return 1;
        }
        elsif ($_ eq 'n' or $_ eq 'N') {
            return 0;
        }
        print "Please enter either 'y' or 'n'... ";
    }

}

sub main {
    my (@args) = @_;
    @ARGV = ();
    my $resp = &print_warning();
    return unless $resp;
    my $rh_options = &$parse_args(@args);
    my $logger = TestInfra::Logger->getLogger('upgrade_testinfra');
    $| = 1;
    $rh_options->{'logger'} = $logger;;
    $rh_options->{'script_dir'} = '/net/slc03psl/scratch/skgupta';
    my $fixImpl = undef;
    # Fix 1: EMDI-705 : TestInfraPlugin name change.
    # TODO : Here we should update any hardcoded references of testinfra version with ${testinfraVersion} 
    $logger->info("Starting to apply EMDI-705");
    $fixImpl = TestInfra::Fix705->new($rh_options);
    $fixImpl->applyFix();

#    $logger->info("Changing the plugin version to 1.1+");
#    TestInfra::Utils::changePluginVersion($rh_options->{'repo_root'}, "1.1+");

    # Fix 2: EMDI-1532 : Migrate to common gradle.properties with a template file.
    $logger->info("Starting to apply EMDI-1532");
    $fixImpl = TestInfra::Fix1532->new($rh_options);
    $fixImpl->applyFix();

    # Fix 3: EMDI-1427 : Use DevInfraPlugin in $repoRoot/build.gradle
    $logger->info("Starting to apply EMDI-1427");
    $fixImpl = TestInfra::Fix1427->new($rh_options);
    $fixImpl->applyFix();

    # Fix 4: EMDI-672 : Removal of testng.xml dependencies
    $logger->info("Starting to apply EMDI-672");
    $fixImpl = TestInfra::Fix672->new($rh_options);
    $fixImpl->applyFix();

    return;
}
&main(@ARGV);
