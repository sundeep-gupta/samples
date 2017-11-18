#!/usr/local/bin/perl

use DBI;
#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################
sub getlrgdbconnection{

  my $user = "acct";
  my $pw = "valid";
  my $dsn = "DBI:Oracle:(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh05-vip.us.oracle.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh06-vip.us.oracle.com)(PORT = 1521)) (LOAD_BALANCE = yes) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = toolsdb.us.oracle.com) ) ) ";
  my $dbh = DBI->connect($dsn,$user,$pw) or die "Couldn't connect to database: " . DBI->errstr;
  return $dbh;
}
## get lrgowner
sub getlrgowner{

  my ($lrgsuite) = @_;
  chomp $lrgsuite;
  my $short_lrgsuite = $lrgsuite;
  $short_lrgsuite =~ s/lrg//g;
# CONFIG VARIABLES
  my $dbh = &getlrgdbconnection();
  my $query = "select owner,dev_manager,area_name,component,sub_component from fowner.v_fowner\$file where filename = lower('emgc_'||'".$short_lrgsuite.".tsc') and product='EMGC' and branch_name='MAIN' and platform_name in('LINUX','LINUX.X64') and rownum=1";
  my $sth = $dbh->prepare($query) or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute() or die "Couldn't execute statement: " . $sth->errstr;
# Read the matching records and print them out          
  my @return_data;
 while (($c1,$c2,$c3,$c4,$c5) = $sth->fetchrow_array()) {
      my $return_str = "$lrgsuite , $c1,$c2,$c3,$c4,$c5";
      push(@return_data,$return_str);
  }
  $sth->finish;
  $dbh->disconnect;
  if(@return_data){
  return $return_data[0];
  }else{
   return $lrgsuite;
  }
}


my $lrglistfile = $ARGV[0];
open (FH, $lrglistfile) or die ("failed to open lrg list file\n");
my @list = <FH>;
close FH;
foreach my $lrglist(@list){
my @lrgarr = split(',',$lrglist);

foreach my $lrgname(@lrgarr){
  my $data= &getlrgowner($lrgname);
  print $data."\n";
}
}
