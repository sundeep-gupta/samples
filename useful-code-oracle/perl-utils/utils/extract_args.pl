#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
my $extract = sub {
    my ($line) = @_;
    
    # STEP 1 : Remove the command first.
    my $rx_command = '\-\>(.*?)\s*\(\s*(.*)?\s*\)\s*;';
    my $command = '';
    my @arguments = ();
    if ($line =~ /$rx_command/) {
        $command = $1;
        my $arguments = $2;
        my @chars = split('', $arguments);
        my $literal = 0;
        my $argument = '';
        my $paranthesis = 0;
        my $escape = 0;
        for (my $i = 0; $i < scalar(@chars); $i++) {
            if ($chars[$i] eq ',') {
                if (not $literal and $paranthesis == 0) {
                    push @arguments, $argument;
                    $argument = '';
                    next;
                }
            }
            else {
                if ($chars[$i] eq '\'') {
                    if (not $escape and $literal eq '\'') {
                        # End of string ''
                        $literal = '';
                    }
                    elsif (not $literal) {
                        $literal = '\'';
                    }
                }
                elsif ($chars[$i] eq '"') {
                    if (not $escape and $literal eq '"') {
                        # End of string "";
                        $literal = '';
                    } elsif (not $literal) {
                        $literal = '"';
                    }
                }
                elsif ($chars[$i] eq '(') {
                    # We are calling function as argument : get_resource_value(
                    if (not $literal) {
                        $paranthesis++;
                    }
                }
                elsif ($chars[$i] eq ')') {
                    if (not $literal) {
                        $paranthesis--;
                    }
                }
                elsif ($literal) {
                    if ($chars[$i] eq "\\") {
                        $escape = not $escape;
                    }
                    else {
                        $escape = 0;
                    }
                }
            }
            $argument .= $chars[$i];
        }
        if ($argument) {
            push @arguments, $argument;
        }
    }
    $arguments[0] = '' unless $arguments[0];
    $arguments[1] = '' unless $arguments[1];
    return ($command, @arguments);
};
my @test_lines = (
'$sel->waitForElementPresent(    "emT:Targets"    );',
'$sel->waitForElementPresent($element);',
'$sel->waitForElementPresent(    "emT:Targets", 10);',
'$sel->waitForElementPresent("emT:Targets");',
'$sel->waitForElementPresent($sel->get_resource_value("com.oracle.sysman.ResourceBundle", "LOGOUT"),200);',
'$sel->waitForElementPresent($sel->get_resource_value("com.oracle.sysman.ResourceBundle", "LOGOUT"));',
'$sel->waitForElementPresent($sel->get_resource_value($rh_value->{"resourcebundle"}, "LOGOUT"));',
'$sel->waitForElementPresent($sel->get_resource_value(get_res_bundle(), "LOGOUT"));',
);
my ($command, $target, $value);
foreach my $line (@test_lines) {
    print $line, "\n";
    ($command, $target, $value) = &$extract($line);
    printf "\tCOMMAND:%s\n\tTARGET:%s\n\tVALUE:%s\n", $command, $target, $value;
}
