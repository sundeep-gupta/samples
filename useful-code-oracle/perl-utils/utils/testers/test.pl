#!/usr/bin/env perl
use strict;
use Socket;
use POSIX;
my $timeout = pack('ll', 5, 100);
print $timeout, "\n";
