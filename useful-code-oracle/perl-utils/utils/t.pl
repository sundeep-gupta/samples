use strict;
my $var = '$sel->refreshAndWait();';
my $obj = '$sel';
my $regex = '\\'. $obj . '\-\>(refreshAndWait|refresh)';
print "VAR : $var\n";
print "REGEX : $regex\n";
if ($var =~ /$regex/) {
    print "MATCHED $1\n";
}
$var = '$sel->refresh()';
if ($var =~ /$regex/) {
    print "MATCHED $1\n";
}
