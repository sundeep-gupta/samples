#!/usr/bin/perl


my @arr1 = ( 'a', 'b', 'd','c', 'e');
my @arr2 = ( 'b', 'd','c', 'e', 'a');
my %hash1 = map {$_ => 1} @arr1;
my %hash2 = map {$_ => 1} @arr2;
foreach my $key (keys %hash1) {
    print $key unless $hash2{$key};
}

