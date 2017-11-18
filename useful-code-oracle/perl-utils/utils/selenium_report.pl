#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use lib $ENV{'HOME'}.'/utils';

sub main {
  my (@args) = @_;
  my ($command, $rh_options) = &parse_args(@args);
  unless ($command and $rh_commands->{$command}) {
    &usage();
    return;
  }

  $sel_report = EM::SeleniumReport->new($rh_options);

  $sel_report->$command($rh_options);
}

sub usage {

}

sub parse_args {


}

&main(@ARGV);
