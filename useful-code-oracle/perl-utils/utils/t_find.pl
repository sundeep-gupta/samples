#!/usr/bin/env perl
use strict;
use warnings;
use File::Find;
my $file = $ENV{'HOME'}.'/extract.pl';
File::Find::find({'no_chdir' => 1, 'wanted' => sub {print $File::Find::name;}},$file);
