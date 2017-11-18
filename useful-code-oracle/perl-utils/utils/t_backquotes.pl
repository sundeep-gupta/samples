#!/usr/bin/env perl

use strict;
my $AVR = $ENV{'ADE_VIEW_ROOT'};
my $command = "xmllint -noout -schema $AVR/emdev/test/selenium/upgrade/client/perl/scripts/navigation_config.xsd $AVR/emcore/test/src/config/navigation_config.xml";
print $command;
my $command_result = `$command 2>&1`;
print "\n-----\n";
print $command_result;
print "\n-----\n";
unless ($command_result =~ /validates/i) {
    print ("ERROR: Schema validation failed. Please run the command, '$command', and ensure the xml is validated.");
}
