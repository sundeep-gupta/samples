#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use lib $ENV{'ADE_VIEW_ROOT'}.'/emgc/emsmf/scripts/smf/thirdparty/pm/CPAN';
use XML::Simple;
print Dumper(%INC);
exit;
my $file = $ENV{'T_WORK'}.'/firefox_profile/mimeTypes.rdf';
my $xs = XML::Simple->new();
my $xml_in = $xs->XMLin($file);
print Dumper($xml_in);

