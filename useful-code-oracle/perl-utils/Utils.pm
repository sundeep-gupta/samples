package Utils;
use Data::Dumper;
use POSIX qw/isdigit/;
use strict;
use Time::HiRes qw/gettimeofday/;
use File::Basename;
use File::Find;
my $DEFAULT_SERIES = 'EMGC_MAIN_LINUX.X64';
# $DEFAULT_SERIES = ' EMGC_PT.12.1.0.4PLT_LINUX.X64';
sub pprint {
    my $msg = shift;
    print $msg, "\n";
}
########################################################################################################
#                    UTILITY METHODS FOR SELENIUM TRIAGE                                               #
########################################################################################################
sub findmatch {
    my ($dir, $rh_) = @_;
}

sub triage_emxt80 {
  my ($label, $lrg) = @_;
  unless ($label and $lrg) {
    pprint "label name and lrg name are must arguments";
    return;
  }
  my $farm_home = $ENV{'FARM_HOME'} || '/net/aimerepos/results';
  my $loc = "$farm_home/$label/$lrg";
  unless (-d "$farm_home/$label/$lrg") {
    pprint("No such directory found : $farm_home/$label/$lrg");
    return;
  }
  # First triage the selenium_start_check.dif
  pprint ("Checking file : selenium_start_check.dif");
  if (-e "$loc/selenium_start_check.dif") {
    pprint("emxt80 due to selenium_start_check.dif");
    &triage_start_check($loc);
  }elsif (-e "$loc/selenium_emconsole_check.dif") {
    pprint("emxt80 due to selenium_emconsole_check.dif");
    &triage_emconsole_check($loc);
  }
   #Test if the dif is due to tvmlgo10.dif 

}

###############################################################################
# 1. If both selenium_browser*.log does not appear and 'VNC with firefox not'
#    match, it is failure due to VNC and firefox not starting properly.
# 2. If selenium_browser.start exist and in 'selenium_broser_start.log' there
#    is an error message saying 'Marker file was not created within 120 sec
#    then this is Firefox delay start issue.
###############################################################################
sub triage_start_check {
  my ($loc) = @_;
  my $start_log = "$loc/selenium_browser_start.log";
  open(my $fh, "$loc/selenium_browser_start.log");
  my @content = <$fh>;
  close($fh);
  chomp @content;
  unless (-e "$loc/selenium_browser.log") {
    pprint "selenium_browser.log does not exist!";
    unless (-e "$loc/selenium_browser.trace.log") {
      pprint "selenium_browser.trace.log not exists";
      # Now check in selenium start log for not started mesage.
      if ( grep {$_ =~ /VNC with Firefox not/i;} @content) {
        pprint "SYMPTOM : Firefox not started propertly.";
      }
    } else {
      open(my $trace_fh, "$loc/selenium_browser.trace.log");
      my @contents = <$trace_fh>;
      close($trace_fh);
      if (grep {$_ =~ /cannot open display/; } @contents ) {
        pprint "SYMPTOM : Firefox failed to launch as it could not connect to display";
      }
    }
  } else {
    open(my $fh, "$loc/selenium_browser.log");
    my @c_browser = <$fh>;
    close($fh);
    if (scalar(@c_browser) <= 11) {
      pprint $c_browser[$#c_browser];
      my @marker = grep {$_ =~ /Marker\sfile\swas\snot\screated\swithin\s120\sseconds/;} @content;
      pprint @marker;
      # TODO : compare timestamps;
      pprint "SYMPTOM : Firefox started after client timeout";
    }
  }
}
########################################################################################
# SELENIUM EMCONSOLE CHECK TRIAGE.
########################################################################################


########################################################################################
# 1. Check if this is new suite issue.
# 2. 
########################################################################################
sub triage_emconsole_check {
  my $dir = shift;

  open(my $fh, "$dir/selenium_emconsole_check.log");
  my @lines = <$fh>;
  chomp(@lines);
  close($fh);
  pprint "Checking if this is new suite.";
  unless (&emconsole_has_username(@lines)) {
    pprint "SYMPTOM: username is missing in the 'type' command of 'selenium_emconsole_check'!";
    pprint "There are two instances of j_username and no username in the log";
    pprint "This could be due to new testsuite!";
    return ;
  }
  my $ra_requests = &parse_em_timing($dir, 'selenium_emconsole_check');
  my $diag_logs = &extract_zip_file($dir);
  pprint "Diagnostics logs available at $diag_logs";
  pprint "Checking if OMS crashed.";
  my $rh_crash = &emconsole_is_oms_crashed($dir, $diag_logs, $ra_requests, @lines);
  if ($rh_crash and scalar @{$rh_crash->{'crash'}} > 0) {
    pprint "SYMPTOM : OMS crashed";
    foreach my $crash (@{$rh_crash->{'crash'}}) {
      pprint $crash;
    }
    return;
  }
  
  # Triage if this is due to delay in loading page.
  pprint "Checking webtier logs to map the requests.";
  my $ra_webtier_logs = &get_webtier_log($diag_logs);
  if (@$ra_webtier_logs > 0) {
    # we got the webtier logs, lets see if all requests are gone to the server
    foreach my $rh_req (@$ra_requests) {
        my $url = $rh_req->{'action'} || $rh_req->{'URL'};
        $url =~ s/\s*,\s*$//;
        $url =~ s/^https:\/\/\w+\.us\.oracle\.com:\d+//;
        #Lets remove ?... after url.. coz otherwise there will be false alarm
        $url =~ s/\?.*$//;
        print "Checking $url :";
        my $ra_logs = [];
        foreach my $logfile (@$ra_webtier_logs) {
            open(my $rh, $logfile);
            my @content = <$rh>;
            chomp @content;
            close($rh);
            $ra_logs = [grep { $_ =~ /$url/; } @content];
        }
        if (scalar @$ra_logs > 0 ) {
            pprint "\nFound AT";
            my $log = &get_closest_match($ra_logs, $rh_req);
            pprint $log;
        } else {
            pprint "Not Found";
        }
    }
  } else {
    pprint "SYMPTOM : No webtier logs found.";
  }
   
  # any other is selenium issue.
# Check if it is a screenshot capturing issue.
}

sub get_closest_match {
  my ($ra_logs, $rh_req) = @_;
  my $ra_logs_ts = [];
  foreach my $log (@$ra_logs) {
    $ra_logs_ts = {'log' => $log, 'timestamp' => &get_timestamp($log, 'DD/MMM/YYYY:HH:MM:SS') };
  }
  print Dumper($rh_req);
  print Dumper( &get_timestamp($rh_req->{'start time'}));
  return $ra_logs->[0];
}

sub get_timestamp {
  my ($time, $format) = @_;
  if ($format eq 'DD/MMM/YYYY:HH:MM:SS') {
    if ($time =~ /(\d{2})\/(\w{3})\/(\d{4})\:(\d+)\:(\d+)\:(\d+)/) {
      return {'day' => $1, 'mon' => $2, 'year'=>$3, 'hr'=> $4, 'min' => $5, 'sec' => $6};
    }
  }elsif ($format eq 'MM-DD-YYYY HH:MM:SS') {
    if ($time =~ /(\d{2})\-(\w{2})\-(\d{4})\s(\d+)\:(\d+)\:(\d+)/) {
      return {'day' => $2, 'mon' => $1, 'year'=>$3, 'hr'=> $4, 'min' => $5, 'sec' => $6};
    }
  }
  return undef;
}

##############################################################################
# 1. Checks if the selenium_emconsole_check.log has the 'username' 
#    in j_username type command. This is to identify if this is new suite 
#    issue.
##############################################################################
sub emconsole_has_username {
  my @username = grep { $_ =~ /type\|j_username::content\|/; } @_;
  if (scalar(@username) == 1 and $username[0] =~ /content\|$/) {
    return 0;
  }
  return 1;
}

sub get_webtier_log {
  my ($diag_dir) = @_;
  my @webtier_logs = ();
  &File::Find::find({'no_chdir'=>1, 'wanted'=>sub {
        push(@webtier_logs,$File::Find::name)
            if ($File::Find::name =~ /\/em_upload_https?_access_log/);
    }},$diag_dir);
  return \@webtier_logs;
}
sub extract_zip_file {
  my ($dir) = @_;
  my $lrgname = $dir;
  $lrgname =~ s/.*\/lrg(\w+)$/$1/;
  unless (-f "$dir/$lrgname.zip") {
    pprint "Could not find the zip file : $dir/$lrgname.zip.";
    return 0;
  }
  my $ts = &gettimeofday();
  mkdir "/tmp/$ts";
  my @output = `unzip $dir/$lrgname.zip -d /tmp/$ts`;
  return "/tmp/$ts";
}
sub emconsole_is_oms_crashed {
  my ($dir, $diag_dir, $ra_requests,   @lines) = @_;
  
  pprint "Checking omsunavailable message.";
  my @omsunavailable = grep { $_->{'URL'} =~ /omsunavailable\.html/} @$ra_requests;
  if (scalar(@omsunavailable) > 0) {
    pprint "This could be a OMS crash issue.";
    pprint "Checking for crash logs...";
  }
  my @crashes = ();
  &File::Find::find({'no_chdir'=> 1,
          'wanted' => sub {
            push(@crashes, $File::Find::name)
                    if (&File::Basename::basename($File::Find::name) =~/^oms.*\.msg$/);
          }
          }, $diag_dir);
  if(scalar(@crashes) > 0) {
    return {'url'=>\@omsunavailable, 'crash' => \@crashes};
  }
  return undef;
}

# Parses the seleniu_em_timing.log and returns the
# array of hash for each requests made for testcase passed
# as argument.
sub parse_em_timing {
  my ($dir, $testcase) = @_;
  unless (-e "$dir/selenium_em_timing.log") {
    pprint "ERROR : selenium_em_timing.log not found in $dir";
    return;
  }
  open(my $fh, "$dir/selenium_em_timing.log");
  my @content = <$fh>;
  chomp @content;
  my @filter = grep {$_ =~ /\s+test\s+name\s+=\s+$testcase\s+,/;} @content;
  close($fh);
  my $ra_requests = [];
  foreach my $req (@filter) {
    my $rh_req = {};
    my @props = split(/\s,\s/, $req);
    foreach my $prop (@props) {
      my ($key, $value) = split(/\s=\s/, $prop);
      $rh_req->{$key} = $value;
    }
    push(@$ra_requests, $rh_req);
  }
  return $ra_requests;
}

########################################################################################################
#                    UTILITY METHODS FOR ADE COMMANDS                                                  #
########################################################################################################
sub create_view {
    my $pattern = shift || 'slc';
    my $series = shift || $DEFAULT_SERIES;
    my $cmd = "ade createview -latest -series $series ";
    my $ra_views = &get_ade_views('all');
    my $ra_existing = [ grep { $_->{'view'} =~ /skgupta_$pattern-/ } @$ra_views];
    my $ra_view_numbers = [];
    foreach my $rh_view (@$ra_existing) {
        my $view = $rh_view->{'view'};
        $view =~ s/skgupta_$pattern-//;
        push (@$ra_view_numbers, $view) if isdigit ($view);
    }
    my $view_name;
    if ((scalar @$ra_view_numbers) > 0) {
        my @sorted = sort { $a <=> $b ; }@$ra_view_numbers;
        my $last = $sorted[-1];
        my $i = (scalar @sorted) + 1;
        if ($last > scalar @sorted) {
            for ( $i = 1; $i < $last; $i++) {
                last unless grep {$_ == $i } @sorted;
            }
        }
        $view_name = $pattern.'-'.$i;
    } else {
        $view_name = $pattern.'-1';
    }
    pprint "Creating view $view_name";
    pprint "$cmd $view_name";
    print `$cmd $view_name`;
    pprint "Done!";
}

sub get_ade_views {
    my $series = shift || $DEFAULT_SERIES;
    my $cmd = "ade lsviews";
    my @cmd_output = `$cmd`;
    chomp @cmd_output;
    if($series ne 'all') {
      my  @filter_output = grep { $_ =~ /${series}_/; } @cmd_output;
      @cmd_output = @filter_output;
    }
    my $ra_views = [];
    foreach my $line (@cmd_output) {
        next if index($line, "|") == -1;
        my ($view, $label, $txn) = split(/\|/, $line);
        $view =~ s/^\s+//; $view =~ s/\s+$//; 
        $label =~ s/^\s+//; $label=~ s/\s+$//;
        $txn =~ s/^\s+//; $txn =~ s/\s+$//;
        push @$ra_views, {'view' => $view, 'label' => $label, 'transaction' => $txn};
    }
    return $ra_views;
}

sub get_free_views {
    my $ra_views = shift;
    return [ grep {$_->{'transaction'} and $_->{'transaction'} eq 'NONE';} @$ra_views ];
}

sub get_used_views {
    my $ra_views = shift;
    return [ grep {$_->{'transaction'} and $_->{'transaction'} ne 'NONE';} @$ra_views];
}

sub get_latest_label {
    my $series = shift;
    my $cmd = "ade showlabels -latest -series $series";
    my @output = `$cmd`;
    chomp @output;
    my $label = ( grep { $_ =~ /${series}_/; } @output)[0];
    $label =~ s/^\s+//; $label =~ s/\s+$//;
    return $label;
}

sub refresh_views {
  my $series = shift || $DEFAULT_SERIES;
  pprint "Getting the list of views for series : $series";
  my $ra_views = &get_ade_views($series);
  pprint "Finding the latest label in the series";
  my $label_latest = &get_latest_label($series);
  pprint "Latest label is : $label_latest";
  my @to_refresh = grep {$_->{'label'} and $_->{'label'} ne $label_latest;} @$ra_views;
  my $ra_free = &get_free_views(\@to_refresh);
  my $ra_used = &get_used_views(\@to_refresh);
  if (scalar @$ra_free) {
    pprint "Refreshing the unused views";
    foreach my $ra_view (@$ra_free) {
        my $cmd = "ade useview " . $ra_view->{'view'} . " -exec " . ' "ade refreshview -label ' . $label_latest .'"';
        pprint "Command run : $cmd";
        my @output = `$cmd`;
    }
    pprint "Done!";
  }
  if (scalar @$ra_used) {
    pprint "Refreshing the used views";
    foreach my $ra_view (@$ra_used) {
        my $cmd = "ade useview " . $ra_view->{'view'} . " -exec " . ' "ade refreshview -label ' . $label_latest .'"';
        pprint "Command run : $cmd";
        my @output = `$cmd`;
    }
    pprint "Done!";
  }
}

sub describe_trans {
    my $trans = shift;
    if ($trans) {

        print `ade describetrans $trans`;
    } elsif ($ENV{'ADE_VIEW_ROOT'}) {
        print `ade describetrans`;
    } else {
        print "Neither give the txn name. Nor inside the view.\nDo you think I am a GOD to find the transaction name ?\n";
    }

}


#######################################################
# Helper methods
########################################################
sub parse_dir {
    my ($dir) = @_;

    my $ra_files = {};
    &Find


}

sub get_lrg_names {
    my ($loc) = @_;
    return [] unless -d $loc;
    opendir(my $dh, $loc);
    my @files = readdir($dh);
    closedir($dh);
    my @lrg_names = ();
    foreach my $f (@files) {
        next if $f =~ /^\.\.?/;
        next unless -d "$loc/$f";
        push @lrg_names , $f;
    }
    return \@lrg_names;
}



sub get_lrgs_running_new_framework {
    my ($result_loc) = @_;
    opendir(my $dh, $result_loc);
    my @ls = readdir($dh);
    closedir($dh);
    my @ls_filtered = grep { $_ ne '.' and $_ ne '..' and -d "$result_loc/$_" and -e "$result_loc/$_/selenium_server.0.log"; } @ls;
    return @ls_filtered;
}


sub get_selenium_test_logs {
    my ($loc) = @_;
 
    opendir (my $dh, $loc);
    my @ls = readdir ($dh);
    closedir($dh);
# TODO : More intelligent logic to get all selenium tests only.
    my @ls_filtered = grep { $_ =~ /\.log$/ } @ls;
    return \@ls_filtered;


}


sub scan_issue_in_testlog {
    my ($callback, $result_loc,  $ra_lrgs, $debug) = @_;
    my @ls_filtered = @$ra_lrgs;
    $debug = 0 unless $debug;
    my $rh_issue = {};
    foreach my $dir (@ls_filtered) {
        my $ra_logs = &get_selenium_test_logs("$result_loc/$dir");
        foreach my $file (@$ra_logs) {
            print "Checking for exception in $dir/$file ..." if $debug;
            if (&$callback("$result_loc/$dir/$file")) {
                print "Found!\n" if $debug;
                $rh_issue->{"$result_loc/$dir/$file"} = 1;
            } else {
                print "Not found!\n" if $debug;
            }
        }
    }
    return $rh_issue;
}
