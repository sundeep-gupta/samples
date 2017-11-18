#!/usr/bin/env perl

use strict;
use warnings;
use File::Find;
use File::Spec;
use File::Copy qw/copy/;
my $copy_em_changes = sub {
    my ($base_dir, $src, $resources) = @_;
    $src = File::Spec->catfile($base_dir, $src);
    my $res = File::Spec->catfile($base_dir, $resources);
    my $dest = File::Spec->catfile($base_dir, 'oracle-em-changes-2.20');
    mkdir ($dest);
    &File::Find::find({'no_chdir' => 1, 'wanted' => sub {
        my $abs_path = $File::Find::name;
        my $rel_path = $abs_path;
        $rel_path =~ s/^$src//;
        my $new_abs_path = File::Spec->catfile($dest, $rel_path);
        return if (($File::Find::name =~ /\.$/ or $File::Find::name =~ /\.\.$/ or $File::Find::name =~ /\.ade_path$/) 
                and (-d $abs_path));
        if (-d $abs_path) {
            mkdir $new_abs_path or warn "Failed to mkdir $new_abs_path : $!\n";
        } else {
            copy $abs_path, $new_abs_path;
        }
    }}, $src);
    &File::Find::find({'no_chdir' => 1, 'wanted' => sub {
        my $abs_path = $File::Find::name;
        my $rel_path = $abs_path;
        $rel_path =~ s/^$res//;
        my $new_abs_path = File::Spec->catfile($dest, $rel_path);
        return if (($File::Find::name =~ /\.$/ or $File::Find::name =~ /\.\.$/ or $File::Find::name =~ /\.ade_path$/) 
                and (-d $abs_path));
        if (-d $abs_path and not -d $new_abs_path) {
            mkdir $new_abs_path or warn "Failed to mkdir $new_abs_path : $!\n";
        } else {
            copy $abs_path, $new_abs_path;
        }
    }}, $res);
};

sub main() {
    &$copy_em_changes($ENV{'ADE_VIEW_ROOT'}.'/emdev/test/selenium/upgrade/server', 'src', 'resources');

}
main();
