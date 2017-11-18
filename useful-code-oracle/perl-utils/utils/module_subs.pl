use strict;
use XML::Simple;
use EMInclude;
use Data::Dumper;
sub list_module {
    my $module = shift;
    no strict 'refs';
    $module .= "::";
    # print Dumper(\%{$module});
    return grep { defined &{$module.$_} } keys %{$module};
    }
}

my @subs = list_module('EMInclude');
print Dumper(\@subs);
