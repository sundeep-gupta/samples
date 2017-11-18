#!/usr/bin/env perl
use strict;
use Data::Dumper;

my $file = $ARGV[0];
die "File not found : $!" unless -e $file;
open(my $fh , $file);
my @list = <$fh>;
close $fh;
chomp @list;
print join (" ", @list);
print "\n";
my @not_done = ();
foreach my $lrgname (@list) {
   print "============================== $lrgname +++++++++\n";
    $lrgname =~ s/^\s+//; $lrgname =~ s/\s+$//;
    $lrgname =~ s/^lrg//;
    my @output = `emfind add_env_file.$lrgname`;
    my @o = grep {$_ =~ /add_env_file\.$lrgname$/ } @output;
    print @o;
    chomp @o;
    if (scalar(@o) > 1) {
        push @not_done, "WARN : Multiple entries for $lrgname. Not changing any file.";
    } elsif (scalar(@o) == 1) {
      my $o = $o[0];
      my $f = $ENV{'ADE_VIEW_ROOT'} .'/'. $o;
      if (-e $f) {
          print `ade co -nc $f`;
          `echo  >> $f`;
          `echo SELENIUM_UPGRADE=1 >>$f`;
          `echo export SELENIUM_UPGRADE >> $f`;
      }
    } else {
        push @not_done, "WARN: Maybe enf file does not exist for $lrgname.";
    }
}
print Dumper(@not_done);
