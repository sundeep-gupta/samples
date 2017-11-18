use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
print time();
print "\n";
my $ff = '/usr/local/packages/firefox_remote/3.6.12/firefox-bin';
my $sel = Test::WWW::Selenium->new( host => "localhost",
                           port => 14458,
                           browser => "*firefox $ff",
                           browser_url => "https://adc6140823.us.oracle.com:4473/" ,
                           'auto_stop' => 0);
syswrite(STDOUT, "Sel created");
print time();
print "\n";
$sel->open_ok("/em");
print time();
print "\n";
sleep 5;
print time();
print "\n";
