#!/usr/bin/env perl
#############################################################################
# Perl script to parse 'selenium_cmd_timing.log' file 
# Functionalities : Find time taken by each test
#                   Find which command in each test takes > cutoff time [ default 600 secs]
#############################################################################
package SeleniumCmdParse;
use strict;
use Time::Local;
use Data::Dumper;
sub new {
    my ($class, $loc) = @_;
    
    unless  ($loc and -e $loc) {
        print "Cannot continue. No LRG with this name : $loc\n";
        return undef;
    }
    my $cmd_file = "$loc/selenium_cmd_timing.log";
    unless (-e $cmd_file) {
        print "$cmd_file does not exist. quitting.\n";
        return undef;
    }
    my $self = {'filepath' => $cmd_file};
    bless $self, $class;
    $self->__process_data();
    return $self;
}

sub __process_data {
    my ($self) = @_;
    my $cmd_file = $self->{'filepath'};
    open(my $fh, $cmd_file);
    my @data = <$fh>;
    chomp(@data);
    close($fh);

    my $rh_selenium_test_stats = &parse_data(\@data);
    &calculate_test_time($rh_selenium_test_stats);
    $self->{'parsed_data'} = $rh_selenium_test_stats;
}

sub get_login_time {
    my ($self, $test) = @_;
    unless ($test) {
        my $rh_selenium_test_stats = $self->{'parsed_data'};
        my $rh_time = {};
        foreach my $testname (keys %$rh_selenium_test_stats) {
            my $ra_raw = $rh_selenium_test_stats->{$testname}->{'raw'};
            my @open_cmds = grep { $_->[3] eq 'open' and $_->[4] =~ /^https:\/\/.*\/em$/} @$ra_raw;
            my @login_click = grep {$_->[3] eq 'click' and $_->[4] eq 'login';} @$ra_raw;
            my @logout_click = grep {$_->[3] eq 'click' and $_->[4] eq 'emT:file_log_out'; } @$ra_raw;
            $rh_time->{$testname} = {'login' => undef, 'logout'=> undef};
            if (scalar (@login_click) == 1) {
                $rh_time->{$testname}->{'login'} = &date_diff($open_cmds[0]->[0], $login_click[0]->[0]);
                # we can calculate the time here.
            } else { 
                # something wrong....?
            }
            if (scalar(@open_cmds) > 1 and scalar (@logout_click) == 1 and $ra_raw->[@$ra_raw -1]->[3] eq 'stop') {
                # can calculate logout time here.
                $rh_time->{$testname}->{'logout'} = &date_diff($open_cmds[$#open_cmds]->[0], $ra_raw->[@$ra_raw -1]->[0]);
            } else {
                # something wrong...
            }
        }
        return $rh_time;
    }
}
sub calculate_test_time {
  my ($rh_selenium_test_stats) = @_;
  foreach my $test (keys %$rh_selenium_test_stats) {
    my $ra_first = $rh_selenium_test_stats->{$test}->{'raw'}->[0];
    my $ra_last = $rh_selenium_test_stats->{$test}->{'raw'}->[ $rh_selenium_test_stats->{$test}->{'raw_cnt'} - 1];
    $rh_selenium_test_stats->{$test}->{'time'} =  &date_diff($ra_first->[0], $ra_last->[0]);
  }
}
sub get_screenshot_delay {
    my ($self, $testname) = @_;
    my $rh_selenium_test_stats = $self->{'parsed_data'};
    my $rh_return  = {};
    if ($testname) {
            my $ra_raw_test = $rh_selenium_test_stats->{$testname}->{'raw'};
            my $cmd_time = 0;
            my $cmd_w_ss = 0;
            foreach my $ra_cmd_time (@$ra_raw_test) {
                $cmd_time = $cmd_time + $ra_cmd_time->[1];
                $cmd_w_ss = $cmd_w_ss + $ra_cmd_time->[2];
            }
            $rh_return->{$testname} = { 'exec_time' => $rh_selenium_test_stats->{$testname}->{'time'},
                    'command' => $cmd_time,
                    'command_with_screenshot' => $cmd_w_ss
            }
    } else {
        foreach my $test (keys %$rh_selenium_test_stats) {
            my $ra_raw_test = $rh_selenium_test_stats->{$test}->{'raw'};
            my $cmd_time = 0;
            my $cmd_w_ss = 0;
            foreach my $ra_cmd_time (@$ra_raw_test) {
                $cmd_time = $cmd_time + $ra_cmd_time->[1];
                $cmd_w_ss = $cmd_w_ss + $ra_cmd_time->[2];
            }
            $rh_return->{$test} = { 'exec_time' => $rh_selenium_test_stats->{$test}->{'time'},
                    'command' => $cmd_time,
                    'command_with_screenshot' => $cmd_w_ss
            }
        }
    }
    return $rh_return;
}

sub get_screenshot_per_command  {
    my ($self, $command) = @_;
    my $rh_selenium_test_stats = $self->{'parsed_data'};
    if ($command) {

    } else {
        my $rh_commands = {'click' => {'cnt' => 0, 'cmd_time' => 0, 'w_ss_time' => 0}, 
                'open' =>  {'cnt' => 0, 'cmd_time' => 0, 'w_ss_time' => 0}, 
                'AndWait' =>  {'cnt' => 0, 'cmd_time' => 0, 'w_ss_time' => 0},
        };
        foreach my $test (keys %$rh_selenium_test_stats) {
            my $ra_raw_test = $rh_selenium_test_stats->{$test}->{'raw'};
            foreach my $raw (@$ra_raw_test) {
                my $cmd = $raw->[3];
                if ( grep { $cmd =~ /$_/;} keys %$rh_commands) {
                    my $k = $cmd;
                    $k = 'AndWait' if ($cmd =~ /AndWait$/);
                    $rh_commands->{$k}->{'cnt'}++;
                    $rh_commands->{$k}->{'cmd_time'} += $raw->[1];
                    $rh_commands->{$k}->{'w_ss_time'} += $raw->[2];
                }
            }
        }
        return $rh_commands;
    }
}
sub find_time_taking_command {
    my($self, $cutoff) = @_;
    my $rh_selenium_test_stats = $self->{'parsed_data'};
    $cutoff = 600 unless $cutoff;
    # TODO 
    my $rh_time_taking_tests = {};
    foreach my $test( keys %$rh_selenium_test_stats) {
        foreach my $raw (@{$rh_selenium_test_stats->{$test}->{'raw'}}) {
            if($raw->[2] >= $cutoff) {
                push @{$rh_time_taking_tests->{$test}}, $raw;
            }
        }
    }
    return $rh_time_taking_tests;
}
sub date_diff2 {
    my ($start_time, $end_time) =@_;
    my $rh_mon = {'Jan' => 0, 'Feb'=>1, 'Mar'=> 2, 'Apr'=>3, 'May' =>4, 'Jun' =>5, 'Jul'=>6, 'Aug'=>7, 'Sep'=>8, 'Oct'=>9, 'Nov' => 10, 'Dec' => 11};
    # Mon Nov 28 2011 04:56:24.354490 PST
    my $ra_start_time = [ (split(/\s+/ , $start_time))[0,1,2,3,5,4] ];
    my $ra_end_time = [ (split(/\s+/, $end_time))[0,1,2,3,5,4] ];
    push(@$ra_start_time, split(':', pop(@$ra_start_time)));
    push(@$ra_end_time, split(':', pop(@$ra_end_time)));
    return undef if scalar @$ra_start_time == 0 or scalar(@$ra_end_time) ==0;
    my $s_time = timegm($ra_start_time->[7],
            $ra_start_time->[6],$ra_start_time->[5],$ra_start_time->[2], $rh_mon->{$ra_start_time->[1]}, $ra_start_time->[3]);
    my $e_time = timegm($ra_end_time->[7],
            $ra_end_time->[6],$ra_end_time->[5],$ra_end_time->[2], $rh_mon->{$ra_end_time->[1]}, $ra_end_time->[3]);
    my $sec_diff = $e_time - $s_time;
    my $ms_diff = $ra_end_time->[7] - $ra_start_time->[7];
    return $ms_diff if $ms_diff > 0;
    return $e_time - $s_time;

}
sub date_diff {
    my ($start_time, $end_time) =@_;
    my $rh_mon = {'Jan' => 0, 'Feb'=>1, 'Mar'=> 2, 'Apr'=>3, 'May' =>4, 'Jun' =>5, 'Jul'=>6, 'Aug'=>7, 'Sep'=>8, 'Oct'=>9, 'Nov' => 10, 'Dec' => 11};
    # Mon Nov 28 2011 04:56:24.354490 PST
    my $ra_start_time = [ (split(/\s+/ , $start_time))[0,1,2,3,5,4] ];
    my $ra_end_time = [ (split(/\s+/, $end_time))[0,1,2,3,5,4] ];
    push(@$ra_start_time, split(':', pop(@$ra_start_time)));
    push(@$ra_end_time, split(':', pop(@$ra_end_time)));
    return undef if scalar @$ra_start_time == 0 or scalar(@$ra_end_time) ==0;
    my $s_time = timegm($ra_start_time->[7],
            $ra_start_time->[6],$ra_start_time->[5],$ra_start_time->[2], $rh_mon->{$ra_start_time->[1]}, $ra_start_time->[3]);
    my $e_time = timegm($ra_end_time->[7],
            $ra_end_time->[6],$ra_end_time->[5],$ra_end_time->[2], $rh_mon->{$ra_end_time->[1]}, $ra_end_time->[3]);
    return $e_time - $s_time;;

}


sub parse_data {
    my ($ra_data) = @_;
    my $rh_selenium_test_stats = {};
    foreach my $line (@$ra_data) {
       $line =~ s/^\s+//g; $line =~ s/\s+$//g;
       next unless $line;
       # Mon Nov 28 2011 04:56:47.162626 PST| tvmlgf36|0.023134|0.023149|type|j_password::content|welcome1
        my ($timestamp, $test, $cmd_time, $tot_cmd_time, $cmd, $arg1, $arg2) = split('\|',$line);
        $test =~ s/^\s+//; $test =~ s/\s+$//;
        unless ($rh_selenium_test_stats->{$test} ){
            $rh_selenium_test_stats->{$test}->{'raw'} = [];
            $rh_selenium_test_stats->{$test}->{'raw_cnt'} = 0;
        }
        $timestamp =~ s/^\s+//; $timestamp =~ s/\s+$//;
        push @{$rh_selenium_test_stats->{$test}->{'raw'}}, [$timestamp, $cmd_time, $tot_cmd_time, $cmd, $arg1, $arg2 ];

        $rh_selenium_test_stats->{$test}->{'raw_cnt'}++;
    }
    return $rh_selenium_test_stats;
}

sub get_test_execution_time {
    my ($self, $test) = @_;
    return $self->{'parsed_data'}->{$test}->{'time'};

}

sub get_test_execution_times {
    my ($self) = @_;
    my %hash = map {$_ => $self->{'parsed_data'}->{$_}->{'time'}; } keys %{$self->{'parsed_data'}};
    return \%hash;
}

sub get_tests {
    my ($self) = @_;
    return [keys  %{$self->{'parsed_data'}}];
}

1;
