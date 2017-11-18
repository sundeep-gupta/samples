#!/usr/local/bin/perl

## This script is to compare 2 labels and report the PID status for the existing diffs
#This will only print for common lrgs between two run (High Level)
# usage perl compare_label.pl <base run path> <current run path> <all/X> [base/current] <num of lab before> <num of labels after> > /tmp/abc.csv
use DBI;
#######################################################################
#######################################################################
#######################################################################
my $argcount = $#ARGV + 1;
my $base_run = $ARGV[0];
my $current_run = $ARGV[1];
my $all_lrg = $ARGV[2];
my $redflag_diff_number = 10;
my @selected_suites;
my $selected_suites_str;

if($argcount >= "3"){
 $compare_base_or_current = $ARGV[3];
 if($argcount >= "4"){
  $compare_with_last_n = $ARGV[4];
  if($argcount >= "5"){
    $compare_with_next_n = $ARGV[5];
    if($argcount >= "6"){
     $selected_suites_str = $ARGV[6];
     @selected_suites = split(',',$selected_suites_str);
    }
   }else{
    $compare_with_next_n = 0;
   }
  ## Get the comma separetd list of suites from text file
  
  }else{
    $compare_with_last_n = 0;
  }
}

chomp $base_run;
chomp $current_run;
chomp $all_lrg;
chomp $print_diffs;
chomp $compare_base_or_current;
#######################################################################
#######################################################################
#######################################################################
sub getlrgdbconnection {
  my $user = "acct";
  my $pw = "valid";
  my $dsn = "DBI:Oracle:(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh05-vip.us.oracle.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = dadbeh06-vip.us.oracle.com)(PORT = 1521)) (LOAD_BALANCE = yes) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = toolsdb.us.oracle.com) ) ) ";
  my $dbh = DBI->connect($dsn,$user,$pw) or die "Couldn't connect to database: " . DBI->errstr;
  return $dbh;
}


## get PID for dif in label
sub getpid{

  my ($lrgsuite,$label,@dif_arr) = @_;
  my $files_str;

  foreach my $dif(@dif_arr){
      $files_str .= "'".$dif."',";
  }
  $file_str=substr($files_str,0,(length($files_str) -1));
# CONFIG VARIABLES
  my $dbh = &getlrgdbconnection();
  my $query = "select  distinct lp.id,lp.remedy,lp.assigned_to,lp.fix_by_date,lp.status from aime.aime\$lrg_symptom ls,aime.aime\$lrg_problem lp where lp.id=ls.prob_id(+) AND ls.file_name in ($file_str) AND ls.label_id ='".$label."' AND ls.lrg_name ='".$lrgsuite."'";

#print $query;exit;
  my $sth = $dbh->prepare($query) or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute() or die "Couldn't execute statement: " . $sth->errstr;
# Read the matching records and print them out          
  my @return_data;
  while (($c1,$c2,$c3,$c4,$c5) = $sth->fetchrow_array()) {
      my $return_str = "[<a href='http://stdevtools.us.oracle.com:7778/lrgconsole/show_problem/".$c1."' >$c1</a> $c2 $c3 $c5 $c4]";
      push(@return_data,$return_str);
  }
  $sth->finish;
  $dbh->disconnect;
  return @return_data;
}
## get PID from list of labels
sub getpid_in_labels{
  my($lrgsuite,$labels_ref,$dif_arr_ref) = @_;
  my @labels = @$labels_ref;
  my @dif_arr = @$dif_arr_ref;
  my $files_str;
  foreach my $dif(@dif_arr){
      $files_str .= "'".$dif."',";
  }
  $file_str=substr($files_str,0,(length($files_str) -1));
  my $labels_str;
  foreach my $lab(@labels){
      $labels_str .= "'".$lab."',";
  }
  $label_str=substr($labels_str,0,(length($labels_str) -1));
  my $dbh = &getlrgdbconnection();
  my $query = "select  distinct lp.id,lp.remedy,lp.assigned_to,ls.file_name from aime.aime\$lrg_symptom ls,aime.aime\$lrg_problem lp where lp.id=ls.prob_id(+) AND ls.file_name in ($file_str) AND ls.label_id  in ($label_str) AND ls.lrg_name ='".$lrgsuite."'";

#print $query;exit;
  my $sth = $dbh->prepare($query) or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute() or die "Couldn't execute statement: " . $sth->errstr;
# Read the matching records and print them out          
  my @return_data;
  while (($c1,$c2,$c3,$c4) = $sth->fetchrow_array()) {
      my $return_str = "[<a href='http://stdevtools.us.oracle.com:7778/lrgconsole/show_problem/".$c1."' >$c1</a> $c2 $c3 $c4]";
      push(@return_data,$return_str);
  }
  $sth->finish;
  $dbh->disconnect;
  return @return_data;
}

sub get_existing_pid{
    my($lrgsuite,$compare_label_list,$difs) = @_;
    my @return_data;
    @return_data = &getpid_in_labels($lrgsuite,$compare_label_list,$difs);
    return @return_data;
}


sub get_label_list{
 my($label,$counterlast,$counternext) = @_;
 my @ret_list;
 my $tmp = reverse($label);
 my $series = reverse(substr($tmp,index($tmp,'_') + 1));
 my @label_list = `ade showlabels -series $series|grep -v TST 2>/dev/null`;
 my($index)= grep $label_list[$_] =~ /$label/, 0..$#label_list;
 if($index){
  for(my $i=($index - $counterlast);$i<($index + $counternext + 1);$i++){
     if($label_list[$i] =~ /$label/){next;}
     push(@ret_list,$label_list[$i]);
  }
 
 }else{
   print "looks like $label does not exists in label series $series... try with option 'base' as 4th argument of comand prompt\n";
   exit;
 }
 return @ret_list;
}
sub getWordCount{
 my ($word,$str)=@_;
 my $count = 0;
 $str =~ s/$word/$count++/eg;
 return $count;
}
sub getReport_html{
  my ($base_run,$current_run,$base_label,$current_label,$redflag_diff_number,$arr_of_lrgs,$labels_list_to_compare) = @_;
  my @array_of_lrgs = @$arr_of_lrgs;
  my $output_str_for_html;
  my %hash;
  $hash{'baseTest'}=$hash{'baseCode'}=$hash{'baseUnknown'}=$hash{'baseTool'}=$hash{'baseEnv'}=0;
  $hash{'newTest'}=$hash{'newCode'}=$hash{'newUnknown'}=$hash{'newTool'}=$hash{'newTool'}=0;
  foreach my $comm_lrg(@array_of_lrgs){
    chomp $comm_lrg;
    my $current_run_dir = $current_run.'/'.$comm_lrg;
    my $base_run_dir = $base_run.'/'.$comm_lrg;
    my $base_run_lrg_suc = `ls $base_run_dir/*suc |wc -l`;
    chomp $base_run_lrg_suc;
    my @base_run_lrg_dif_files = `ls $base_run_dir/*dif`;
    my $base_run_lrg_dif = ( $#base_run_lrg_dif_files + 1);
    if ($base_run_lrg_dif == -1){
        $base_run_lrg_dif =0;
    }
    unshift(@base_run_lrg_dif_files,'junk');
    my $tot_base = $base_run_lrg_suc + $base_run_lrg_dif;
    my $current_run_lrg_suc = `ls $current_run_dir/*suc |wc -l`;
    chomp $current_run_lrg_suc;
    my @current_run_lrg_dif_files = `ls $current_run_dir/*dif`;
    my $current_run_lrg_dif = ($#current_run_lrg_dif_files + 1);
    if ($current_run_lrg_dif == -1){
      $current_run_lrg_dif =0;
    }
    unshift(@current_run_lrg_dif_files,'junk');
    my $tot_current = $current_run_lrg_suc + $current_run_lrg_dif;
    my $new_diffs;
    my $tot_dif = ($tot_base - $tot_current);
    my $diff_files = '';
    my @new_dif;
    map {$_ =~ s/.*\///g} @base_run_lrg_dif_files;
    my @arr1_base = @base_run_lrg_dif_files;
    chomp @arr1_base;
    map {$_ =~ s/.*\///g} @current_run_lrg_dif_files;
    my @arr1_curr = @current_run_lrg_dif_files;
    chomp  @arr1_curr;
    foreach my $dif(@arr1_curr){
        my($index)= grep $arr1_base[$_] =~ /$dif/, 0..$#arr1_base;
        if (!$index){
            chomp $dif;
            push(@new_dif,$dif);
        }
    }

    #get PID for  all base dif
    my @pid_data_base=&getpid($comm_lrg,$base_label,@arr1_base);
    #get PID for  all new dif
    my @pid_data=&getpid($comm_lrg,$current_label,@new_dif);
    # get new dif history
    my @pid_ex_data = &get_existing_pid($comm_lrg, $labels_list_to_compare,\@new_dif);
    #get PID for  all current dif
    my @pid_data_curr=&getpid($comm_lrg,$current_label,@arr1_curr);
  ####################################################################################################
  ###################GET HTML FOR DATA################################################################
     map {$_ =~ s/junk//g} @new_dif;
     $new_diffs = $#new_dif;
     $base_dif_str = join('<br>',@pid_data_base);
     $curr_dif_str = join('<br>',@pid_data_curr);
     $hash{'baseTest'} +=  &getWordCount('TEST',$base_dif_str);
     $hash{'baseCode'} +=  &getWordCount('CODE',$base_dif_str);
     $hash{'baseUnknown'} +=  &getWordCount('UNKNOWN',$base_dif_str);
     $hash{'baseTool'} +=  &getWordCount('TOOL',$base_dif_str);
     $hash{'baseEnv'} +=  &getWordCount('ENV',$base_dif_str);
     #print "COUNT:$hash{'baseTest'};$hash{'baseCode'}; $hash{'baseUnknown'}:$hash{'baseTool'}\n";
     $new_dif_str = join('<br>',@new_dif);
     $new_dif_pid_str = join('<br>',@pid_data);
     $hash{'newTest'} +=  &getWordCount('TEST',$new_dif_pid_str);
     $hash{'newCode'} +=  &getWordCount('CODE',$new_dif_pid_str);
     $hash{'newUnknown'} +=  &getWordCount('UNKNOWN',$new_dif_pid_str);
     $hash{'newTool'} +=  &getWordCount('TOOL',$new_dif_pid_str);
     $hash{'newEnv'} +=  &getWordCount('ENV',$new_dif_pid_str);
     $ex_dif_pid_str = join('<br>',@pid_ex_data);
     $rh_common_lrgs->{$comm_lrg} = {
            'base_run_lrg' => $base_run_lrg,
            'base_run_lrg_dif' => $base_run_lrg_dif,
            'base_dif_str' => $base_dif_str,
            'tot_base' => $tot_base,
            'current_run_lrg_suc' => $current_run_lrg_suc,
            'current_run_lrg_dif' => $current_run_lrg_dif,
            'tot_current'  => $tot_current, 
            'new_diffs_html' => $new_diffs_html,
            'tot_dif_html' => $tot_dif_html,
            'new_dif_str' => $new_dif_str,
            'new_dif_pid_str' => $new_dif_pid_str,
            'ex_dif_pid_str' => $ex_dif_pid_str,
            'curr_dif_str' => $curr_dif_str
     };

    if($new_diffs > $redflag_diff_number){
       $new_diffs_html = "<font color='red'><b>$new_diffs</b></font>";
     }else{
       $new_diffs_html = $new_diffs;
     }
     if($tot_dif > $redflag_diff_number){
         $tot_dif_html = "<font color='red'><b>$tot_dif</b></font>";
     }else{
         $tot_dif_html = $tot_dif;
     }
    $output_str_for_html .= "<TR><TD >$comm_lrg</TD><TD BGCOLOR='#F0E68C'>$base_run_lrg_suc</TD><TD BGCOLOR='#F0E68C'>$base_run_lrg_dif</TD><TD  BGCOLOR='#F0E68C'>$base_dif_str</TD><TD BGCOLOR='#F0E68C'>$tot_base</TD><TD BGCOLOR='#00FFFF'>$current_run_lrg_suc</TD><TD BGCOLOR='#00FFFF'>$current_run_lrg_dif</TD><TD BGCOLOR='#00FFFF'>$tot_current</TD><TD BGCOLOR='#FFC0CB'>$new_diffs_html</TD><TD BGCOLOR='#FFC0CB'>$tot_dif_html</TD><TD BGCOLOR='#FFC0CB'>$new_dif_str</TD><TD BGCOLOR='#FFC0CB'>$new_dif_pid_str</TD><TD BGCOLOR='#C0C0C0'>$ex_dif_pid_str</TD><TD>$curr_dif_str</TD></TR>";
  ####################################################################################################
  ####################################################################################################
  }
  my $has = \%hash;
  return ($output_str_for_html,$has);
}
#######################################################################################################
#######################################################################################################
#######################################################################################################
#######################################################################################################

my $r1 = reverse($base_run);
my $r2 = reverse($current_run);
my %h; my %ha;
my $base_label = reverse(substr($r1,0,index($r1,'/')));
my $current_label = reverse(substr($r2,0,index($r2,'/')));
my @labels_list_to_compare;
if($compare_base_or_current =~ /base/){
 @labels_list_to_compare = &get_label_list($base_label,$compare_with_last_n,$compare_with_next_n);
}else{
 @labels_list_to_compare = &get_label_list($current_label,$compare_with_last_n,$compare_with_next_n);
}
chomp(@labels_list_to_compare);
chdir($base_run);
my @base_dir_lrgs = `ls |grep -v xml`;
chdir($current_run);
my @current_dir_lrgs = `ls |grep -v xml`;
my @un = ();
my @inter = ();
my @diff_arr = ();
my @intersect = ();
my @difference_arr = ();
my %count= ();
my @base_run_suc;
my @base_run_dif;
#####################GET COMMON LRGS#######################
foreach $element (@base_dir_lrgs, @current_dir_lrgs) { $count{$element}++ }
foreach $element (keys %count) {
    push @un, $element;
    push @{ $count{$element} > 1 ? \@intersect : \@difference_arr }, $element;
}
if(@selected_suites){
   chomp @selected_suites;
   foreach my $sel_suite(@selected_suites){
     my(@indexes_match_suite_1)= grep $intersect[$_] =~ /$sel_suite/, 0..$#intersect;
     foreach my  $ind(@indexes_match_suite_1){
       push(@inter,$intersect[$ind]);
     }
     my(@indexes_match_suite_2)= grep $difference_arr[$_] =~ /$sel_suite/, 0..$#difference_arr;
     foreach my  $ind(@indexes_match_suite_2){
       push(@diff_arr,$difference_arr[$ind]);
     }

   }
   
}else{
 @inter = @intersect;
 @diff_arr = @difference_arr;
} 

#################If list of specific LRGs are provided---Keep list of LRG specfic########### 


############################################################

my $label_used_to_compare = join("<br>",@labels_list_to_compare);
########################################HTML PAGE HEADER ###########################
my $output_file_content_html = '<HTML><BODY><P>Comparitive report between <b>'.$base_label.'</b> and <b>'.$current_label.'</b></P>';
$output_file_content_html .= '<P>Labels Used to compare <b>'.$label_used_to_compare.'</b></P>';
$output_file_content_html .= '<Table border="1"><TR BGCOLOR="#FFC0CB"><TD>--</TD><TD colspan="4" BGCOLOR="#F0E68C">'.$base_label.'</TD><TD colspan="3" BGCOLOR="#00FFFF">'.$current_label.'</TD><TD colspan="6" BGCOLOR="#FFC0CB"> Extra Diff details</TD><TD BGCOLOR="#C0C0C0">--</TD><TD></TD></TR>';
$output_file_content_html .= '<TR BGCOLOR="#FFFF00"><TD>LRG-Name</TD><TD>SUC</TD><TD>DIF</TD><TD>BASE PID</TD><TD>TOT</TD><TD>SUC</TD><TD>DIF</TD><TD>TOT</TD><TD>EXTRA_DIF</TD><TD>TOTAL_DIF</TD><TD>EXTRA DIF FILES</TD><TD>PIDS FOR EXTRA DIFS</TD><TD>DIFF HISTORY FROM OTHER LABEL</TD><TD>CURR_PID</TD></TR>';
####################################################################################

##############################GET DATA#############################################

my ($output_file_content,$h1) = &getReport_html($base_run,$current_run,$base_label,$current_label,$redflag_diff_number,\@inter,\@labels_list_to_compare);
 $output_file_content_html .=$output_file_content;

 %h=%$h1;
if ($all_lrg =~ 'all'){
    ($output_file_content,$h2) = &getReport_html($base_run,$current_run,$base_label,$current_label,$redflag_diff_number,\@diff_arr,\@labels_list_to_compare);
    $output_file_content_html .=$output_file_content;
    %ha=%$h2;
}
$output_file_content_html .= '</Table>';
my $PID_count = "Base Label PID <br> TEST=".($h{'baseTest'} + $ha{'baseTest'})."  CODE=".($h{'baseCode'}+$ha{'baseCode'})."    UNKNOWN=".($h{'baseUnknown'}+$h{'baseUnknown'})." TOOL=".($h{'baseTool'}+$ha{'baseTool'})."  ENV=".($h{'baseEnv'}+$ha{'baseEnv'})."<BR>";
 $PID_count .= "CURRENT Label New PID<br> TEST=".($h{'newTest'} + $ha{'newTest'})."  CODE=".($h{'newCode'}+$ha{'newCode'})."  UNKNOWN=".($h{'newUnknown'}+$ha{'newUnknown'})."   TOOL=".($h{'newTool'}+$ha{'newTool'})."   ENV=".($h{'newEnv'}+$ha{'newEnv'})."<BR>";

$output_file_content_html .= $PID_count.'</BODY></HTML>';
#3 print the files
my $filename = $base_label."_vs_".$current_label;
$filename =~ s/\./_/g;
my $HTML_filename = "/tmp/compared_".$filename.".html";
    open(FH,">$HTML_filename") or die "cannot open file $HTML_filename";
    print FH "$output_file_content_html";
    close(FH);



print "Please look at the files  $HTML_filename \n";

