use strict;
use warnings;
my $file = '2014-10-28 Nokia C2-01.nbu';

open(my $fh, $file);
my @lines = <$fh>;
chomp @lines;
close $fh;
my $rh_vcard = {};
my $ra_vcards = [];
my $vCardStart = 0;
foreach my $line (@lines) {
    if ($line =~/END:VCARD/) {
        $vCardStart = 0;
        push @$ra_vcards, $rh_vcard;
        next;
    }
    if ($line =~ /BEGIN:VCARD/) {
        $vCardStart = 1;
        $rh_vcard = {};
        next;
    }
    if ($vCardStart) {
        if($line =~ /^N;/) {
            my ($junk, $name) = split(':', $line);
            my ($last, $first) = split(';', $name);
            $rh_vcard->{'name'} = "$first $last";
            next;
        }
        if ($line =~ /^TEL;/) {
            my ($junk, $phone) = split(':', $line);
            if ($rh_vcard->{'phone'}) {
                push @{$rh_vcard->{'phone'}}, $phone;
            }
            else {
                $rh_vcard->{'phone'} = [$phone];
            }
            next;
        }
        if ($line =~ /^VERSION/) {
            next;
        }
    }
}
foreach my $rh_entry (@$ra_vcards) {
    foreach my $key(keys %$rh_entry) {
        my $val = $rh_entry->{$key};
        if (ref($val) eq 'ARRAY') {
            foreach my $e (@$val) {
                print ", $e";
            }
        }
        else {
            print $rh_entry->{$key};
        }
    }
    print "\n";
}
