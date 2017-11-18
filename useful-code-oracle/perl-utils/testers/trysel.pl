use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;
print time();
print "\n";
my $sel = Test::WWW::Selenium->new( host => "localhost",
                                    port => 4444,
                                                                        browser => "*firefox",
                                                                                                            browser_url => "http://http://adc6140823.us.oracle.com:8080/" ,
                                                                                                                                );
syswrite(STDOUT, "Sel created");
print time();
print "\n";
$sel->open_ok("/");

$sel->stop();
