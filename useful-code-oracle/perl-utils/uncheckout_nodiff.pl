#!/usr/bin/env perl
use strict;
use Data::Dumper;
my $avr = $ENV{'ADE_VIEW_ROOT'};
die "No ADE_VIEW_ROOT" unless $avr and -e $avr;
my $rh_co_elems = &get_checkedout_files();
my @header_diff_files = ();
foreach my $file (@{$rh_co_elems->{'reserved'}}) {
    print $file,"\n" unless &is_header_diff_only($file) == 1;
}
local $" = "\n";
print "@header_diff_files";
sub is_header_diff_only {
    my ($file) = @_;
    return unless -e $file;
    my @output = `ade diff -pred $file`;
    chomp @output;
    return 1 if $#output == 2; # No diff at all
    @output = (@output)[3,];
    my @keywords = ('$Id', '$Header', '$Revision');
    while(@output > 1) {
        if($output[0] =~ /\d+\w\d+/ and $output[2] =~ /^\-+$/ and
           grep { $output[1] =~ /$_/ and $output[3] =~ /$_/ } @keywords ) {
            @output = (@output)[3,];
            if (@output < 4) {
                # we found atleast one dif which is not kw dif.
                return undef;
            }
        } else {
            # we found atleast one dif which is not kw dif.
            return undef;
        }
    }
    return 1;
}

sub get_checkedout_files {
    my @output = `ade lsco`;
    chomp @output;
    return if $output[0] =~ /^No files checked-out in view/;
    my $rh_co_elems = { 'reserved' => [], 'refresh' => [] };
    my $co_type = '';
    foreach my $line (@output) {
        $line =~ s/^\s+//; $line =~ s/\s+$//;
        # ignore decorations
        next if $line =~ /^\-$/;
        $co_type = 'reserved' if $line =~ /RESERVED/;
        $co_type = 'refresh' if $line =~ /REFRESH/;
        push @{$rh_co_elems->{$co_type}}, $line if -e $line;
    }
    return $rh_co_elems;
}
