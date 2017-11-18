#!/usr/bin/perl
use strict;
use lib $ENV{'HOME'}.'/utils';
use Utils;

&Utils::triage_emxt80(@ARGV);
