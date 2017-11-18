#!/usr/bin/perl

$result_loc=$ARGV[0];
$ref_time=$ARGV[1];

if ( ! $ARGV[1] )
{
$ref_time=10
}
if ( ! $ARGV[0] ) {
print "No result location given\n";
print "Usage: check_delay.pl <Result loc> <Ref time>\n";
exit 0;
}
if ( ! -e $result_loc ) {
print "$result_loc not exist\n";
print "Usage: check_delay.pl <Result loc> <Ref time>\n";
exit 0;
}

open(FILE2,">$ENV{PWD}/result.out") or die "Can't open file $ENV{PWD}/result.out for writing";
open ( FILE1, "$result_loc/selenium_cmd_timing.log") or die "Can't open file $result_loc/selenium_cmd_timing.log";
$line_no=1;
my @fnames;
while (<FILE1>)
{
@line_arr=split(/\|/);
($tmp,$test_name)=split(/] +/,$line_arr[0]);
if ( ! $prev_test_name)
{
$prev_test_name=$test_name;
$fname="/tmp/$test_name".".out";
open(FILE3,">$fname") or die "Can't open file $fname  for writing";
push(@fnames,$fname);
}

if ( $test_name ne $prev_test_name )
{
$prev_test_name=$test_name;
close(FILE3);
$fname="/tmp/$test_name".".out";
open(FILE3,">$fname") or die "Can't open file $fname  for writing";
push(@fnames,$fname);
}

if ( $line_arr[2] >= $ref_time )
{
$time_taken=$line_arr[2];
splice(@line_arr,0,4);
$lin_str=join('|',@line_arr);
print FILE3 "$time_taken Secs|$test_name|Line No:$line_no|$lin_str";
}
$line_no++;
}
foreach $str (@fnames) 
{
if ( -s $str )
{
$v1=`sort -g -r $str`;
$_=$str;
m#/tmp/(.*).out#;
print FILE2 "Test $1 commands that took run time greater than $ref_time\n";
print FILE2 "------------------------------------------------------------\n";
print FILE2 "Time taken|Test Name|selenium_cmd_timing.log line|Command details\n";
print FILE2 "$v1";
print FILE2 "\n";
}
}
if ( -s "$ENV{PWD}/result.out" )
{
print "Found some selenium command took > $ref_time Secs, Please check $ENV{PWD}/result.out file for more details\n";
}
else
{
print "No selenium command took > $ref_time Secs\n";
}
