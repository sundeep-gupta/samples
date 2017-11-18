#!/usr/local/bin/perl
# 
# $Header: emdev/test/src/utl/selenium_start_check.pl /main/12 2013/02/27 00:25:47 rchellia Exp $
#
# selenium_start_check.pl
# 
# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      selenium_start_check.pl - selenium startup tests
#
#    DESCRIPTION
#      Sanity tests to check Selenium start/stop & prerequisite checks.
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    rchellia    02/13/13 - check for prerequisite jars used in
#                           GetResourceValue
#    semuruga    09/15/10 - Update firefox 3 version
#    vaikrish    02/20/09 - Creation
# 
use strict;
use warnings;
use WWW::Selenium;
use locale;
use EMInclude; # let this remain, so any PERL5LIB issues are caught here, though its a remote possibility.

# Refer to user guide for the options
my $sel = WWW::Selenium->init_selenium('selenium_start_check');

#Test script generated on [ Fri Feb 20 2009 17:48:58 GMT+0530 (India Standard Time) ]
$sel->getEval('navigator.userAgent');
# Capturing screenshot as part of selenium_start_check
# to load the 'Robot' in Selenium RC. Otherwise it will be loaded
# when emconsole_check is called, adding to the login time.
$sel->screenShot();

# check for required Resource jar files
$sel->check_resource_availability();

$sel->stop;

