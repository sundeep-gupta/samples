#!/usr/bin/perl
use strict;
use Date::Calc qw(:all);
use Date::Manip qw(ParseDate UnixDate);
my $result_loc=$ARGV[0];
my $ref_time=$ARGV[1] || 600;;
my $output_file = $ARGV[2] || $ENV{'HOME'}.'/result.out';
unless ($ARGV[0] ) {
    print "No result location given\n";
    print "Usage: check_delay.pl <LRG Result Loc> <Optional:Ref time(Default is 600 Sec)>\n";
    print "Example: check_delay.pl  /net/aimerepos/results/EMCORE_MAIN_GENERIC_080420/lrgemg52\n";
    exit 0;
}
unless (-e $result_loc ) {
    print "$result_loc not exist\n";
    print "Usage: check_delay.pl <LRG Result Loc> <Optional:Ref time(Default is 600 Sec)>\n";
    print "Example: check_delay.pl  /net/aimerepos/results/EMCORE_MAIN_GENERIC_080420/lrgemg52\n";
    exit 0;
}
unless (-r $result_loc . '/selenium_cmd_timing.log') {
    print "File $result_loc/selenium_cmd_timing.log is not present or not readable.\n";
    return 0;
}
if (-z $result_loc. '/selenium_cmd_timing.log') {
    print "File is of zero length : $result_loc/selenium_cmd_timing.log\n";
    return 01;
}
# TODO : don't use backquotes.
my $histfilename=`ls  $result_loc/*history.log`;
chop($histfilename);


my @fnames;
my ($month,$day,$year,$hh,$mm,$ss);
my ($month2,$day2,$year2,$hh2,$mm2,$ss2);
my ($tmpmonth2,$tmpday2,$tmpyear2,$tmphh2,$tmpmm2,$tmpss2);
open(my $fh_output,">$output_file") or die "Can't open file $output_file for writing.";
open ( my $fh_input, "$result_loc/selenium_cmd_timing.log") or die "Can't open file $result_loc/selenium_cmd_timing.log";
while (<$fh_input>) {
    my @line_arr=split(/\|/);
    if ( $line_arr[2] >= $ref_time ) {
        $time_taken=$line_arr[2];
        if ( $line_arr[0] =~ /]/ ) {
            ($tmp,$test_name)=split(/] +/,$line_arr[0]);
            ($tmp1,$dtime)=split(/\[/,$tmp);
        } else {
            $dtime=$line_arr[0];
        }
        $lin_str=join('|',@line_arr);
        print $fh_output "\nLine from selenium_cmd_timing file: $lin_str\n";
        
        #parsing the date and form date which can be used to compare in history file.
        ($dtime1,$tmp1)=split(/\./,$dtime);
        ($month,$day,$year,$hh,$mm,$ss) = UnixDate($dtime1,"%m","%d","%Y","%H","%M","%S");

        #Add 5.00 hours to convert time zone.
        ($yeart2,$montht2,$dayt2,$hht2,$mmt2,$sst2) = Add_Delta_DHMS( $year,$month,$day,$hh,$mm,$ss,00,05,00,00);
        $date_to_text = Date_to_Text($yeart2,$montht2,$dayt2);
        ($t1,$monthstr,$t2)=split(/-/,$date_to_text);
        print $fh_output "Found a selenium command took $time_taken(>$ref_time) at\t\t:$dtime\n";
        print $fh_output "Added 5.00 hours for timezone convertion\t\t:$monthstr $dayt2 $yeart2 $hht2:$mmt2:$sst2\n";
        
        #Parse suitename.history file to get CPU,IO,Load average details
        open(my $fh_history,"$histfilename") or die "Can't open file $histfilename for reading";
        $number_of_read=0;

        #We need to subtract number of secs the command run to find the starting time of the command
        #Then we need to calculate the load from starting time to Command ending time.
        ($num_sec_taken,$ttr1)=split(/\./,$time_taken);
        
        # Adding 2 mins to check load from little before the command start
        $num_sec_taken=$num_sec_taken+120;

    ($year2,$month2,$day2,$hh2,$mm2,$ss2) = Add_Delta_DHMS( $yeart2,$montht2,$dayt2,$hht2,$mmt2,$sst2,0,0,0,-$num_sec_taken);
    $date_to_text = Date_to_Text($year2,$month2,$day2);
    ($t1,$monthstr,$t2)=split(/-/,$date_to_text);

    #Finding Number of records we need to check
    ($number_of_try,$ttr2)=split(/\./,($num_sec_taken/60));
    #Following line will be useful if we give reference value less than 60 Secs.
     $number_of_try=$number_of_try+2;    
        print $fh_output "Subtracted $num_sec_taken ($time_taken+120) Secs to find starting time of cmd \t:$monthstr $day2 $year2 $hh2:$mm2:$ss2\n\n";
    #print $fh_output "Timestamp\t\tOne min Load avg\tMemery Avg\tCPU usage\tIO Wait\n";
    print $fh_output "Timestamp\t\tOne min Load avg\tIO Util\n";
    $number_of_read=0;
        while (<$fh_history>)
        {
            if (/DATE:/)
            {
                if ( $number_of_read >= $number_of_try ) {
                    last;
                }
                
                for($i=0;$i<25;$i++)
                {
                    ($tmpyear2, $tmpmonth2, $tmpday2, $tmphh2, $tmpmm2, $tmpss2) = Add_Delta_DHMS( $year2, $month, $day2, $hh2, $mm2, $ss2, 0, 0, $i, 0 );
                    $tmpdate_to_text = Date_to_Text($tmpyear2,$tmpmonth2,$tmpday2);
                    ($t1,$tmpmonthstr,$t2)=split(/-/,$tmpdate_to_text);
            if ( $tmphh2 < 10 ) {
            $tmphh2="0"."$tmphh2";
            }
            if ( $tmpmm2 < 10 ) {
            $tmpmm2="0"."$tmpmm2";
            }
            if ( $tmpday2 < 10 ) {
            $tmpday2="0"."$tmpday2";
            }
#print "trying DATE: $monthstr $tmpday2 $tmpyear2 $tmphh2:$tmpmm2\n";
                    if (/DATE: $monthstr $tmpday2 $tmpyear2 $tmphh2:$tmpmm2/)
                    {
#                        print "2nd for loop - match found - value of read  nois $number_of_read -DATE: $monthstr $tmpday2 $tmpyear2 $tmphh2:$tmpmm2\n";
                        write_to_responce("DATE: $monthstr $tmpday2 $tmpyear2 $tmphh2:$tmpmm2");
                        $number_of_read++;
                        #last;
                    }
                    if ( $number_of_read >= $number_of_try ) {
                       last;
                    }
                }
            }
        }
    }
}
close($fh_input);
close($fh_output);
close($fh_history);
#$v1=`ls -l $ENV{PWD}/result.out`;
#print $v1;
if ( -s "$ENV{PWD}/result.out" )
{
    print "Found some selenium command took > $ref_time Secs, Please check $ENV{PWD}/result.out file for more details\n";
}
else
{
    print "No selenium command took > $ref_time Secs\n";
}

sub write_to_responce
{
    ($date_to_check)=@_;
    #print "date to check:$date_to_check:\n";
    $histfilename=`ls  $result_loc/*history.log`;
    chop($histfilename);
    open(FILE4,"$histfilename") or die "Can't open file $histfilename for reading";
    $readcnt=0;
    while (<FILE4>)
 {
    if ( /$date_to_check/ )
    {
        /(.*)/;
        $cdate1=$1;
    ($sp1,$cdate)=split(/DATE: /,$cdate1);
    if ($readcnt==0) {
       $readcnt=1;
        }
    }
   
    if ( $readcnt==1) 
    { 
      if ( /DATE:/ )
      {
     if (!/$date_to_check/)
    {
        last;
    }
      }
      if (( /Mem:/ ) && ( /total/))
      {
    /Mem:( +)([0-9]+)k total,( +)([0-9]+)k used,(.*)/;
    $totalv=$2;
    $userv=$4;
    $memper=($userv/$totalv)*100;
    $memper=sprintf("%.2f",$memper);
      }
      if ( /load average/)
      {
        /(.*)(load average:)(.*?,)(.*)/;
        ($load_avg,$ts1)=split(/,/,$3);
        
      }
      if ($read_next_line_iowait == 1 )
      {
        #($t1,$cpu_uage,$t3,$t4,$iowait,$t5)=split(/ +/);
    @ioutil=split(/ +/);
    $cnt11=scalar(@ioutil);
    $ioutil1=@ioutil[$cnt11-1];
#    print $ioutil1."\n";
#    print @ioutil."\n";
        $read_next_line_iowait=0;
    
      }
      if ( /Device:/ )
      {
        {
            #print ;
            $read_next_line_iowait=1;
        }
        
      }

    }
 }
close(FILE4);
#print $fh_output "$cdate\t$load_avg\t\t\t$memper\t\t$cpu_uage\t\t$iowait\n";
print $fh_output "$cdate\t$load_avg\t\t\t$ioutil1";
}    
