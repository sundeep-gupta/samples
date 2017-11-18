package SeleniumBrowserStartLogParser;

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
    $self->{'filepath'} = "$loc/selenium_browser_start.log";
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

    my $rh_selenium_test_stats = $self->parse_data(\@data);
   # &calculate_test_time($rh_selenium_test_stats);
    $self->{'data'} = $rh_selenium_test_stats;
}


sub parse_data {
    my ($self, $ra_data) = @_;
    foreach my $line (@$ra_data) {
        if ($line =~ /Selenium Browser Startup/) {
            $self->{'start'} = $line; next;
        }
        if ($line =~ /VNC with Firefox not started successfully/) {
            $self->{'end_time'} = $line;
            last;
        }
    }
}

1;
