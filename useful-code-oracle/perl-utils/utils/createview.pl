#!/usr/bin/env perl
use strict;

use lib $ENV{'HOME'}. '/utils';
use Utils;
&Utils::create_view(@ARGV);
