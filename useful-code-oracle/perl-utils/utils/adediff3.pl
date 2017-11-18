#!/usr/bin/env perl
my  $adediff_cmd = '/usr/local/packages/jdk15/bin/java -Xms128m -Xmx512m -jar /usr/local/nde/ade/diffmergevhv/deploy/diffmergevhv.jar merge -gui ';
my $file = $ARGV[0];

my $OLDDIR = '/scratch/skgupta/2.2/core';
my $YOURDIR = '/scratch/skgupta/2.20/core';
my $MYDIR = '/ade_autofs/ade_base/EMGC_MAIN_LINUX.X64.rdd/LATEST/emdev/test/selenium/upgrade/source/resources/selenium_core';


my $command = "$adediff_cmd $OLDDIR/$file $YOURDIR/$file $MYDIR/$file $file";
print `ade co -nc $file`;
print `$command`;
print "Running ade diff -pred ";
print `ade diff -pred -gui $file`;
