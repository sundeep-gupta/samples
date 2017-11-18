#!/usr/bin/env perl

use strict;

my $__private = sub {
    my $arg = shift;
    print "Hello I am called. $arg";
};

&$__private("Sundeep");
