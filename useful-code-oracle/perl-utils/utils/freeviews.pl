#!/usr/bin/perl
use strict;
use lib $ENV{'HOME'}.'/utils';
use Utils;
my $ra_views = &Utils::get_free_views('EMGC_MAIN_LINUX');
foreach my $vw (@$ra_views) {
    &Utils::pprint($vw->{'view'});
}
my $ra_views = &Utils::get_free_views('EMGC_MAIN_LINUX.X64)';
foreach my $vw (@$ra_views) {
    &Utils::pprint($vw->{'view'});
}
