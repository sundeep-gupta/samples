use strict;
use warnings;
my @a = ('testname', 'selenium_');
my (%h) = @a;
use Data::Dumper;

my $rh_args = {@a};
print Dumper($rh_args);
