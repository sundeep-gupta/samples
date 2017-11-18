package SeleniumBrowserLogParser;

use strict;
use warnings;
use Data::Dumper;
sub new {
    my ($package, $loc) = @_;
    unless ($loc and -e $loc) {
        print "Cannot continue. No LRG with this name. $loc.\n";
        return undef;
    }
    my $self = {};
    bless ($self, $package);
    $self->{'filepath'} = "$loc/selenium_browser.log";
    unless (-e $self->{'filepath'}) {
        print "The file , ". $self->{'filepath'} . " does not exist. Please provide correct path.\n";
        return undef;
    }
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
   # &calculate_test_time($rh_selenium_test_stats);
    $self->{'data'} = $rh_selenium_test_stats;
}
sub parse_data {
    my ($ra_data) = @_;
    my $testname = undef;
    my $command = undef;
    my $ra_log_parsed = [];
    my $rh_command_parsed = {};
    my $rh_test_parsed = {};
    foreach my $line (@$ra_data) {
       $line =~ s/^\s+//g; $line =~ s/\s+$//g;
       next unless $line;
       # Mon Nov 28 2011 04:56:47.162626 PST| tvmlgf36|0.023134|0.023149|type|j_password::content|welcome1
       # [INFO  2012-May-14 11:58:13.713 +0][none none] SECURITY_MODE Enabled false
       if ($line =~ /^\[(\w+)\s+(.*?)\]\[(\w+)\s+(\w+)\]\s+(.*)$/) {
 #         print "LOG - $1, TIME - $2, TEST - $3, COMMAND - $4, - MESSAGE - $5\n";
          unless ($testname and $testname eq $3) {
              push (@{$rh_test_parsed->{'commands'}}, $rh_command_parsed);
              push (@$ra_log_parsed, $rh_test_parsed) if $testname;
              $testname = $3;
              $rh_test_parsed = {'testname' => $3, 'commands' => []};
          } 
          unless ($command and $command eq $4) {
              push (@{$rh_test_parsed->{'commands'}}, $rh_command_parsed);
              $command = $4;
              $rh_command_parsed = {'name' => $4, 'messages' => [], 'timestamps' => []};
          }
          push @{$rh_command_parsed->{'messages'}}, $5;
          push @{$rh_command_parsed->{'timestamps'}}, $2;
       }
    }
 #   print Dumper($ra_log_parsed);
    return $ra_log_parsed;
}

sub get_testnames {
    my ($self) = @_;
    my @commands = ();
    foreach my $command (@{$self->{'data'}}) {
        push @commands, $command->{'testname'};
    }
    return \@commands;
}
1;

