#!/usr/local/bin/perl
print "Content-type:text/html\r\n\r\n";
farmshowjobs();

sub farmshowjobs
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
   print "<pre>".getlrgdetails($farmjobid,getjobdetails($farmjobid))."</pre>";
  }else{
   print "Invalid farmjobid: $farmjobid";
  }
 }
}

sub getjobdetails
{
 my($jobid)=@_;
 my $jobdetails=`/usr/local/bin/farm showjobs -d -j $jobid`;
 my @jobdetailsArray=split(/\n/,$jobdetails);
 return @jobdetailsArray;
}

sub getlrgnames
{
 my(@jobdetails)=@_;
 my($lrglist)=grep(/Regress Names/,@jobdetails);
 chomp($lrglist);
 $lrglist=~s/ +/ /;
 $lrglist=~s/ Regress Names +://;
 $lrglist=~s/^ +//g;
 $lrglist=~s/ +$//g;
 $lrglist=~s/ /, /g;
 return $lrglist;
}
sub getlrgdetails
{
 my($jobid,@jobdetails)=@_;
 my $returnval="";
 #my($resultsloc)=grep(/Results location/,@jobdetails);
 #$returnval=$resultsloc."<br>";
# my($lrglist)=grep(/Regress Names/,@jobdetails);
# chomp($lrglist);
# $lrglist=~s/ +/ /;
# $lrglist=~s/ Regress Names +://;
# $lrglist=~s/^ +//g;
# $lrglist=~s/ +$//g;
 #my(@lrgs)=split(/ /,$lrglist);
 #print "<br>$lrglist<br>";
 #foreach(@lrgs)
 my $lrgstart=0;
 $returnval.=$jobdetails[1]."\n";
 $returnval.=$jobdetails[2]."\n";
 $returnval.=$jobdetails[3]."\n";
 foreach(@jobdetails)
 {
  my $line=$_;
  # my $lrgname=$_;
  ## print "<br>";
  # my($regressnames,$lrgdetail)=grep(/$lrgname/,@jobdetails);
  # print $lrgdetail;
  # $returnval.=$lrgdetail."<br>";
  if($line=~m/(base label|Results location|Regress Names|Regress Names|submit command|view name|txn name)/ || $lrgstart)
  {
   $returnval.=$line."\n";
  }
  elsif($line=~m/LRGs/)
  {
   $lrgstart=1;
   $returnval.=$line."\n";
  }
 }
 #$returnval.=$lrglist."<br>";
 return $returnval;
}
1;
