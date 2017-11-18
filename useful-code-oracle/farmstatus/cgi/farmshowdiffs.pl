#!/usr/local/bin/perl
print "Content-type:text/html\r\n\r\n";
farmshowdiffs();

sub farmshowdiffs
{
 $ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
 my $buffer;
 my %FORM;
 if ($ENV{'REQUEST_METHOD'} eq "GET")
 {
  $buffer = $ENV{'QUERY_STRING'};
 }
 my @pairs = split(/&/, $buffer);
 foreach $pair (@pairs)
 {
  my($name, $value) = split(/=/, $pair);
  $value =~ tr/+/ /;
  $value =~ s/%(..)/pack("C", hex($1))/eg;
  $FORM{$name} = $value;
 }
 my $farmjobid=$FORM{jobid};
 if($farmjobid)
 {
  if($farmjobid=~/^[0-9]*$/)
  {
   print "<pre>".getjobdiffdetails($farmjobid)."</pre>";
  }else{
   print "Invalid farmjobid: $farmjobid";
  }
 }
}

sub getjobdiffdetails
{
 my($jobid)=@_;
 my $jobdiffdetails_temp=`/usr/local/bin/farm showdiffs -j $jobid`;
 my @jobdiffdetails=split(/\n/,$jobdiffdetails_temp);
 #print @jobdiffdetails;
 my $returnval="";
 my $i=1;
 while($jobdiffdetails[$i])
 {
  my $line=$jobdiffdetails[$i];
  $returnval.=$line."\n";
  $i++;
 }
 return $returnval;
}
1;
