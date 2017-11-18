#!/usr/local/bin/perl
use DBI;
use Data::Dumper;
use Time::Local;

my $label1 = $ARGV[0];
my $label2 = $ARGV[1];
my $what = $ARGV[2];


##########################
#####################
sub getlrgdbconnection{
    my $user = "acct";
    my $pw = "valid";
    my $dsn = "DBI:Oracle:(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh05-vip.us.oracle.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh06-vip.us.oracle.com)(PORT = 1521)) (LOAD_BALANCE = yes) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = toolsdb.us.oracle.com) ) ) ";
    my $dbh = DBI->connect($dsn,$user,$pw) or die "Couldn't connect to database: " . DBI->errstr;
    return $dbh;
}

sub getlrgs{

  my ($label) = @_;
  my @return_data;
# CONFIG VARIABLES
  my $dbh = &getlrgdbconnection();
  my $query = "select  distinct lrg_name from aime.aime\$lrg_result where label_id ='".$label."' order by testsfailed desc";
  my $sth = $dbh->prepare($query) or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute() or die "Couldn't execute statement: " . $sth->errstr;
  while (($c1) = $sth->fetchrow_array()) {
      push(@return_data,$c1);
  }
  $sth->finish;
  $dbh->disconnect;
  return @return_data;
}
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
      my $return_str = "$c1,$c2,$c3,$c4,$c5";
      push(@return_data,$return_str);
  }
  $sth->finish;
  $dbh->disconnect;
  return $return_data[0];
}

my @lrg1 = getlrgs($label1);
my @lrg2 = getlrgs($label2);
chomp @lrg1;
chomp @lrg2;

my @difference_arr;
my @output_arr;
my @union=@lrg2;

foreach my $lrg(@lrg1){
my ($index) = grep $lrg2[$_] =~ /$lrg/, 0..$#lrg2;
if(!$index){
 push(@difference_arr,$lrg);
 push(@union,$lrg);
}

}
if ($what =~ /union/){
print "Union of Suites that are present in $label1 and $label2 \n";

 @output_arr = @union;
}elsif($what =~ /diff/){
print "Suites that are present in $label1 but not in $label2 \n";
 @output_arr = @difference_arr;
}else{
print "Suites that are present $label2 \n";
 @output_arr = @lrg2;
}

print "LRG,OWNER, DEV-OWNER,AREA,COMPONENT,SUB-COMPONENT \n"; 


foreach my $suite (@output_arr){
my $owner = getlrgowner($suite);
print "$suite , $owner"."\n";
}

