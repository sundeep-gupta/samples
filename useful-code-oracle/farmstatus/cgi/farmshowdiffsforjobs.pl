#!/usr/local/bin/perl
print "Content-type:text/html\r\n\r\n";
print "<div>";
farmshowjobs();
print "</table></div>";
print "<div id=\"lrginfo\"></div></div>";

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
 my $username=$FORM{u};
 my $sincedays=$FORM{since};
 my $txn=$FORM{txn};
 my $farmjobid=$FORM{jobid};
 if($farmjobid)
 {
  if($farmjobid=~/^[0-9]*$/)
  {
    $farmjobidoption=" -j $farmjobid";
  }else{
   print "Invalid FarmjobId. Omitting it<br>";
  }
 }
 if(!$username && !$farmjobid && !$txn)
 {
   print "<h1>Please specify the username or FarmjobID or Transaction name</h1>";
   return;
 }else{
  $usernameoption=" -u $username" if($username);
 }
 if($sincedays)
 {
  if($sincedays=~/^[0-9]*$/)
  {
   $sinceoption=" -since $sincedays";
  }else{
   print "Invalid/unsupported since option($sincedays). Omitting it<br>";
  }
 }
 my $txnoption="-txn $txn" if($txn);
 my $farmcmd="/usr/local/bin/farm showjobs $usernameoption $sinceoption $txnoption $farmjobidoption";
 #print $farmcmd."<br>";
 my @farmjobstatus=`$farmcmd`;
 my $i=4;
 if(!$farmjobstatus[$i])
 {
   print "<h1>No farm jobs records rightnow for your options!</h1><br>Command: $farmcmd";
   return;
 }
 print "<div class='divscroll'><table style='width:100%'><tr><th></th><th>Job#</th><th>Date</th><th>Transaction name</th><th>JobStatus</th><th>LRG Names</th><th>Ongoing</th><th>Done</th></tr>\n";
 $i=scalar(@farmjobstatus)-1;
 while($i>=4)
 {
  chomp($farmjobstatus[$i]);
  $farmjobstatus[$i]=~s/ +/ /g;
  my ($jobid,$jdate1,$jdate2,$jdate3,$desc,$txn,$status,$ongoing,$total)=split(/\ /,$farmjobstatus[$i]);
  my $rowcolor="#ffffff";
  $rowcolor="runningjob" if($status=~/running/i);
  $rowcolor="finishedjob" if($status=~/finished/i);
  $rowcolor="failedjob" if($status=~/failed/i);
  $rowcolor="abortedjob" if($status=~/aborted/i);
  #if($status=~/(running|finished)/i)
  #{
   my @jobOutput=getjobdetails($jobid);
   my $lrglist=getlrgnames(@jobOutput);
   my $resultsloc=getresultsloc(@jobOutput);
   $txn = gettxnname(@jobOutput);
   #my $details="<h2>Farm Job: $jobid</h1><pre>".getlrgdetails($jobid,@jobOutput)."</pre>";
   my $details="<h2>Farm Job: $jobid</h1><input type=\\'button\\' onclick=\\'showjobdetails($jobid);\\' id=\\'showjobsbtn\\' value=\\'Showjobs\\'/><input type=\\'button\\' onclick=\\'showfarmdiffdetails($jobid);\\' id=\\'showdiffsbtn\\' value=\\'Showdiffs\\'/><input type=\\'button\\' onclick=triagefarm(\\'$resultsloc\\'); id=\\'triagebtn\\' value=\\'Triage\\'/><div id=\\'lrgjobdifdetails\\' class=\\'lrgjobdifdetails\\'><pre>".getlrgdetails($jobid,@jobOutput)."</pre></div>";
   $details=~s/\n//g;
   print "\n<tr id=\"tr".($i-4)."\" onmouseOut=\"mouseoutcolor(this)\" onmouseover=\"mouseovercolor(this)\" onclick=\"javascript:document.getElementById('lrginfo').innerHTML='".$details."';highlightrow(this);\"  >";
   #print "\n<tr id=\"tr".($i-4)."\" onclick=\"javascript:document.getElementById('lrginfo').innerHTML='".$details."';highlightrow(this);\" onmouseOut=\"javascript:this.className='nonhighlightedrow'\" onmouseover=\"javascript:this.className='highlightedrow'\">";
  #}else{
  # print "<tr id=\"tr".($i-4)."\">";
  #}
  print "<td class=\"rowhead\"></td>";
  print "<td >$jobid</td>";
  print "<td >$jdate1 $jdate2 $jdate3</td>";
  print "<td >$txn</td>";
  print "<td class=\"$rowcolor\">$status</td>";
  print "<td>$lrglist</td>";
  if($total)
  {
   print "<td >$ongoing</td>";
  }else{
   print "<td> </td>";
   $total=$ongoing;
  }
  print "<td>$total </td>";
  print "</tr>";
  $i--;
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

sub getresultsloc
{
 my(@jobdetails)=@_;
 my($resultsloc_line)=grep(/Results location/,@jobdetails);
 chomp($resultsloc_line);
 my($resultsloc_label,$resultsloc)=split(/:/,$resultsloc_line);
 $resultsloc=~s/^\s*//;
 $resultsloc=~s/\s*$//;
 return $resultsloc;
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
 $returnval.=$jobdetails[1]."\n<br>";
 $returnval.=$jobdetails[2]."\n<br>";
 $returnval.=$jobdetails[3]."\n<br>";
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
   $returnval.=$line."\n<br>";
  }
  elsif($line=~m/LRGs/)
  {
   $lrgstart=1;
   $returnval.=$line."\n<br>";
  }
 }
 #$returnval.=$lrglist."<br>";
 return $returnval;
}

sub gettxnname
{
 my(@jobdetails)=@_;
 foreach(@jobdetails)
 {
  my $line=$_;
  chomp($line);
  if($line=~m/txn name/)
  {
   my ($txntext,$txnname)=split(/:/,$line);
   $txnname=~s/^\s*//g;
   $txnname=~s/\s*$//g;
   return $txnname;
  }
 }
 return;
}
1;
