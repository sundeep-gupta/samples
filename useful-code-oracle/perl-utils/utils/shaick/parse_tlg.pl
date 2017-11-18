my $file = $ARGV[0];
my %test_details;
my $flag=0;
my $start_time;
my $end_time;
my $time_name;
my @testnames=();
my $DEBUG=0;
use Date::Calc qw(:all);
use Date::Manip qw(ParseDate UnixDate DateCalc);

open (FILE,$file) or die "Opening file failed $!";
while(<FILE>)
{


  if (/RUNTEST.*Executing.*T_SOURCE/)
  {
	#print "Some test found\n" if ($DEBUG);
	#print if ($DEBUG);
	$start_time=$_;
	$test_name=$_;
	$start_time=~s/.*on(.*) ./\1/g;
	$test_name=~s/.*:(.*) on.*/\1/g;
	chomp($start_time);
	chomp($test_name);
	print "start time is $start_time\n" if ($DEBUG);
  	print "test name is $test_name\n" if ($DEBUG);
  	$test_details { "$test_name" }{'start_time'}="$start_time";
	next;
  }
  
  if (/RUNTEST.*Finished/)
  {
    $end_time=$_;
    $test_name=$_;
    $end_time=~s/.* on (.*) ./\1/g;
    $test_name=~s/.*:(.*) on.*/\1/g;
	chomp($test_name);
	chomp($end_time);
  $test_details { "$test_name" }{'end_time'}="$end_time";
  print "end time is $end_time\n" if ($DEBUG);
  	print "test name is $test_name\n" if ($DEBUG);

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

print "Accessing hash \n";
foreach my $masterkey (keys %test_details)
{
   print "First level: $masterkey\n";
   foreach my $key (keys %{$test_details{$masterkey}}) 
   {
      print "$key => $test_details{$masterkey}{$key}\n"; 
   } 
}
