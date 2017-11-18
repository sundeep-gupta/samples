use strict;
my $file = "numbers.txt";
open(my $fh, $file);
my @numbers = <$fh>;
chomp @numbers;
close $fh;
my $s = 0;
foreach my $n (@numbers) {
    $s += $n;
}
print $s, "\n";
