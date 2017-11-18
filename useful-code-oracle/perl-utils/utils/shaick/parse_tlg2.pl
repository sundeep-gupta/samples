my $path;
my $files;
my $file;
if ( -d $ARGV[0] )
{
print "Given path is Directory and is exists, Calculating time for all tlg files in that directory\n";
@files = glob("$ARGV[0]/*.tlg");
}
elsif ( -f $ARGV[0] )
{
print "Given path is a file and is exist, Calculating time for the given tlg file\n";
$files[0]=$ARGV[0];
}


my %test_details;
my $flag1=0;
my $flag2=0;
my $start_time;
my $end_time;
my $time_name;
my @testnames=();
my $DEBUG=0;
my $suite_start_time;
my $suite_end_time;
my $suite_running_time;
use Date::Calc qw(:all);
use Date::Manip qw(ParseDate UnixDate DateCalc);
foreach $file (@files)
{
$suite_start_time="";
$suite_end_time="";
$suite_running_time="";
%test_details={};
open (FILE,$file) or die "Opening file failed $!";
print "\n\n";
print "Now checking file $file\n";
print "==========================================================\n";
while(<FILE>)
{

  if ( /Ora\*Tst:/)
  {
   $suite_start_time=$_;
   $suite_start_time=~s/^Ora\*Tst:.*; (.*)/\1/g;
   chomp($suite_start_time);
  }

  if ( /REPORT.*Report generated to TLG on/)
  {
    $suite_end_time=$_;
    $suite_end_time=~s/.*on (.*)/\1/g;
    chomp($suite_end_time);
  }



  if (/^>\s+EXECARGV/)
  {
	#print "Some test found\n" if ($DEBUG);
	#print if ($DEBUG);
	$test_name=$_;
	$test_name=~s/.*EXECARGV\s+(.*)/\1/g;
	chomp($test_name);
	next if ($test_name=~/logmine/);
	$flag=1;
	next;
  }
  if ( $flag == 1 )
  {
        $start_time=$_;
	$start_time=~s/.* on (.*)/\1/g;
	$flag=2;
	next;

  }
  if ($flag ==2 )
  {
    $end_time=$_;
    $end_time=~s/.* on (.*)/\1/g;
    chomp($test_name);
    chomp($end_time);
    chomp($start_time);
    $test_details { "$test_name" }{'end_time'}="$end_time";
    print "test name is $test_name\n" if ($DEBUG);
    print "start time is $start_time\n" if ($DEBUG);
    print "end time is $end_time\n" if ($DEBUG);
   
    #Assigning to Hash.
    $test_details { "$test_name" }{'start_time'}="$start_time";
    $test_details { "$test_name" }{'end_time'}="$end_time";


 
    #reset the values.
    $flag=0;
    $test_name="";
    $end_time="";
    $start_time="";
    next;
 
  }
  
}
close(FILE);


# Accessing the hash

print "Accessing hash \n"if ($DEBUG);
foreach my $masterkey (keys %test_details)
{
   print "First level: $masterkey\n"if ($DEBUG);
   foreach my $key (keys %{$test_details{$masterkey}}) 
   {
      print "$key => $test_details{$masterkey}{$key}\n" if ($DEBUG); 
   } 
}
print "calculating delta \n"if ($DEBUG);
$suite_running_time=&DateCalc($suite_start_time,$suite_end_time,\$err);
foreach my $masterkey (keys %test_details) 
{
print "First level: $masterkey\n"if ($DEBUG);
print "start time is $test_details{$masterkey}{'start_time'}" if ($DEBUG);
print "end time is $test_details{$masterkey}{'end_time'}" if ($DEBUG);
my $date1=&ParseDate($test_details{$masterkey}{'start_time'});
my $date2=&ParseDate($test_details{$masterkey}{'end_time'});
print "Date1 is $date1\n" if ($DEBUG);
print "Date2 is $date2\n" if ($DEBUG);
my $err;
my $delta=&DateCalc($date1,$date2,\$err);
print "Time different is $delta and error string is $err \n" if ($DEBUG);
$test_details{$masterkey}{'time_taken'}=$delta;
   
}
if ($suite_running_time)
{
my ($year,$month,$week,$day,$hour,$min,$sec)= split(/:/,$suite_running_time);
if ( ($hour > 0) || ($min >10) )
{
print "Suite starting time:$suite_start_time\n";
print "Suite completed on:$suite_end_time\n" if ($suite_end_time);
print "Suite Running time:$suite_running_time\n" if ($suite_end_time);
}
}
else
{
print "Suite either hung or didn't complete\n"
}
print "Accessing hash of hash\n";
foreach my $masterkey (keys %test_details)
{
my ($year,$month,$week,$day,$hour,$min,$sec)= split(/:/,$test_details{$masterkey}{'time_taken'});
if ( ($hour > 0) || ($min >10) )
{
   print "Test call is: $masterkey\n";
   foreach my $key (keys %{$test_details{$masterkey}}) 
   {
      print "$key => $test_details{$masterkey}{$key}\n"; 
   } 
}
}
}
