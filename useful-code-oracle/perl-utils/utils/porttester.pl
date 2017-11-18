
#!/usr/bin/perl -w
# porttester will check a list of hosts to see if specific ports are open
# like nmap, but allows you to print out what you want, in the way you want
# (like a CSV - as nmap is kinda noisy and doesn't dump well to spreadsheets)
# based off code snippets from perlmonks.org

# instructions for use:
# specify the ports you want to look for in %port_hash.  tcp/udp must be specified too
# to run it, type:  perl porttester.pl > outpout.csv
# prints:
# a.com,22
# b.com
# c.com,3389,22
# d.com,3389
# 10.1.1.1,22

use strict;
use IO::Socket::PortState qw(check_ports);

# this is the icmp timeout
my $timeout = 1;

# use the format as per below to add new ports
# perl is not going to be as fast a nmap, this is
# a specialized tool to check for RDP and SSH
# and print it out to a spreadsheet, use nmap!

my $proto = 'tcp';

my %port_hash = (
        $proto => {
            22     => {},
            3389   => {},
        }
    );

# loop over __DATA__ and process line by line
while (<DATA>){
    my $host = $_;
    # strip off the new line character
    chomp($host);

    # get a hash ref (I think that's the data structure returned)
    my $host_hr = check_ports($host,$timeout,\%port_hash);

    # print whatever host this
    print "$host";

    # loop over each key in the hash that matches $proto (tcp), so 22 and 3389
    for my $port (keys %{$host_hr->{$proto}}) {

        # if it's open, say "yes", else say "no"
        my $yesno = $host_hr->{$proto}{$port}{open} ? "yes" : "no";

        # if it's "yes", then print it out
        if ($yesno eq 'yes') {
            print ",$port";
        }
    }

    # add a new line for formatting
    print "\n";
}
