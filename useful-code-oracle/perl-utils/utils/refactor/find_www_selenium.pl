#!/usr/bin/env perl

use strict;
use warnings;
use File::Find;
sub main {
    my $dir = $ENV{'ADE_VIEW_ROOT'};
    open (my $log, ">/home/skgupta/files_with_www_selenium.log");
    unless($dir) {
        print $log "You must run this script within a view.\n";
        return;
    }
#    print $log "Searching the files with WWW::Selenium.\n";
#    my $rh_files_with_www_selenium = &get_files_with_www_selenium($dir, $log);
#    print $log "Finished searching for files.\n";
#    open(my $fh, ">/home/skgupta/files_with_www_selenium.txt");
#    foreach my $file (keys %$rh_files_with_www_selenium) {
#        print $fh $file,"\n";
#    }
#    close $fh;
    open(my $fh ,"/home/skgupta/files_with_www_selenium.txt");
    my @files = <$fh>;
    chomp @files;
    close($fh);
    my %hash = map { $_ => 1;} @files;
    my $rh_files_with_www_selenium = \%hash;
    # Now we have list of files with us.
    
    foreach my $file (keys %$rh_files_with_www_selenium) {
        print $log "-" x 120;
        print $log "\n$file\n";
        print $log "-" x 120;
        print "\n";

        my @output = `ade co -c 'new namespace for selenium' $file`;
        if ( grep { $_ =~ /^ade ERROR/; } @output ) {
            print $log "[ERROR] Failed to checkout $file\n";
            next;
        } elsif ( grep { $_ =~ /^Checked out /;} @output ) {
            print $log "[INFO] Successfully checked out the file.\n";
            &replace_www_selenium($file, $log);
        } else {
            print $log "[ERROR] Neither ade error nor checkout\n ";
            print $log @output;
        }
    }
    close($log);
}


sub replace_www_selenium {
    my ($file, $log) = @_;
    my $search = 'WWW::Selenium';
    my $replace = 'Oracle::EM::Selenium';
    unless (-e $file) {
        print $log "[ERROR] File does not exist\n";
        return;
    }
    print $log "[INFO] Reading file content.\n";
    open(my $fh, $file);
    my @data = <$fh>;
    close($fh);

    print $log "[INFO] Changing the content.\n";
    my $cnt = 0;
    foreach my $line (@data) {
        if ($line =~ /$search/) {
            $cnt++;
            $line =~ s/$search/$replace/g;
        }
    }
    print $log "[INFO] Replaced in $cnt lines.\n";
    print $log "[INFO] Writing new content.\n";
    open( $fh, ">$file");
    print $fh @data;
    close $fh;
    print $log "[INFO] Done.\n";
}


sub get_files_with_www_selenium {
    my ($dir, $log) = @_;
    print $dir,"\n";
    my $rh_files = {};
    &File::Find::find( {'no_chdir'=> 1,'wanted' => sub {
            if (-f $File::Find::name) {
                open(my $fh, $File::Find::name) or warn "unable to open $File::Find::name\n";
                if ($fh) {
                    foreach my $line (<$fh>) {
                        $rh_files->{$File::Find::name} = 1 if $line =~ /WWW::Selenium/;
                        syswrite(STDOUT,'.');
                    }
                    close($fh);
                }   
            }
    }}, $dir.'/');
    return $rh_files;
}
main();
