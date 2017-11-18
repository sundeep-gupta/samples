#!/usr/bin/env perl

use strict;
use warnings;

my @array = ("Send Command:click\n", "Got Result :OK,", "Send Command: type", "Got Result : ERROR : element not found");

print $1 if @array =~ /ERROR (.*)/;

