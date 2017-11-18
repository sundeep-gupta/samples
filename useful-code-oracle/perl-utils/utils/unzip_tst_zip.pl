#!/usr/bin/env perl
use strict;
use File::Find;
my $dir = '/tmp/perlscript';
`rm -rf $dir`;
my $test = $ARGV[0];
-e $test.'.zip' or die "File $test.zip does not exist.\n";
`unzip $test.zip -d $dir`;

my $rh_files = {};

&File::Find::find( {'nochdir' => 1, 
    'wanted' => sub {
        if (($File::Find::name =~ /\.(html)$/ ) or ($File::Find::name =~ /\.(png)$/)) {
            $rh_files->{$1} = [] unless $rh_files->{$1};
            push @{$rh_files->{$1}}, $File::Find::name;
        }
        
    }
}, $dir);
my @sorted = sort { my $val1 = $a; my $val2 = $b; $val1 =~ s/.*_(\d+)\.html$/$1/; $val2 =~ s/.*_(\d+)\.html$/$1/; return $val1 <=> $val2; } @{$rh_files->{'html'}};
# For now we only need html 
foreach my $file (@sorted) {
    print $file, "\n";
}
