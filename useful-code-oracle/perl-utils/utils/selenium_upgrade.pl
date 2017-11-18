#!/usr/bin/env perl

use strict;
use File::Find;
use Data::Dumper;
use Digest::MD5;
use File::Copy qw/copy/;

my $new_ver_dir = $ARGV[1];
my $old_ver_dir = $ARGV[0];
my $file = $ARGV[2] || $ENV{'HOME'}.'/selenium_upgrade_diff_report.txt';
my $rh_new_version = &get_files($new_ver_dir);
my $rh_old_version = &get_files($old_ver_dir);

my $rh_diff = &compare_versions($rh_old_version, $rh_new_version);
open my $fh, ">".$file;
foreach my $key (keys %$rh_diff) {
    print $fh '-'x 120;
    print $fh "\n", $key,"\n";
    print $fh '-' x 120,"\n";
    foreach my $file (@{$rh_diff->{$key}}) {
        print $fh $file,"\n";
    }
}
print "Created file $file\n";
#print Dumper($rh_diff->{no_change});

exit(1);

# &create_new_dirs($rh_diff->{'new_dirs'},  $old_ver_dir, $new_ver_dir);
print "Copying new files ...\n";
&copy_new_files($rh_diff->{'new_files'}, $old_ver_dir, $new_ver_dir);
#&delete_files($rh_diff->{'deleted_files'}, $old_ver_dir, $new_ver_dir);
#&delete_dirs($rh_diff->{'deleted_dirs'}, $old_ver_dir, $new_ver_dir);
print "Replacing existing files ...\n";
&replace_old($rh_diff->{'content'}, $old_ver_dir, $new_ver_dir);
close($fh);

sub replace_old {
    my ($ra_diff_files, $dira, $dirb) = @_;
    print $fh '-'x 120;
    print $fh "\nReplacing old files\n";
    print $fh '-' x 120,"\n";
    foreach my $file (@$ra_diff_files) {
        print $fh `ade co -c 'upgraded selenium version' $dira/$file`;
        copy "$dirb/$file", "$dira/$file";
    }
}
sub create_new_dirs {
    my ($ra_new_dirs, $dira, $dirb) = @_;
    print $fh '-'x 120;
    print $fh "\nCreating new files\n";
    print $fh '-' x 120,"\n";
    foreach my $new_dir (@$ra_new_dirs) {
        print $fh `ade mkdir $dira/$new_dir`;
    }
}

sub copy_new_files {
    my ($ra_new_files, $dira, $dirb) = @_;
    foreach my $new_file (@$ra_new_files) {
        print $fh `ade mkelem -c 'upgraded selenium version' -recursive $dira/$new_file`;
        copy $dirb.'/'. $new_file, $dira . '/' . $new_file;
    }
}


sub delete_files {
    my ($ra_del_files, $dira, $dirb) = @_;
    foreach my $del_file (@$ra_del_files) {
        unlink $dira.'/'. $del_file;
    }
}



sub delete_dirs {
    my ($ra_del_dirs, $dira, $dirb) = @_;
    foreach my $del_dir (@$ra_del_dirs) {
        rmdir $dira.'/'. $del_dir;
    }
}


sub get_files {

    my ($dir) = @_;
    my $rh_files = {'root' => $dir};
    File::Find::find( {no_chdir=>1, wanted => sub {
        my $base = &File::Basename::basename($File::Find::name);
        my $name = $File::Find::name;
        $name =~ s/^$dir\/?//;

        return if $base eq '.ade_path' or $base eq '.' or $base eq '..';
        return if $name eq '';
        if (-d $File::Find::name) {
            $rh_files->{'dir'}->{$name} = 1;
        } else {
            $rh_files->{'files'}->{$name} = &get_md5_file($File::Find::name);
        }
            }}, $dir);
    return $rh_files;
}

sub compare_versions {
    my ($rh_a, $rh_b) = @_;
    my $rh_diff = {};
    my $rh_diffc = {};
    # print deleted dirs in b
    foreach my $dir (keys %{$rh_a->{'dir'}}) {
        push (@{$rh_diff->{'deleted_dirs'}}, $dir) unless $rh_b->{'dir'}->{$dir};
    }
    # Print new  dirs in b
    foreach my $dir (keys %{$rh_b->{'dir'}}) {
        push (@{$rh_diff->{'new_dirs'}}, $dir) unless $rh_a->{'dir'}->{$dir};
    }

    # print deleted files  in b
    foreach my $file (keys %{$rh_a->{'files'}}) {
        push (@{$rh_diff->{'deleted_files'}}, $file) unless $rh_b->{'files'}->{$file}
    }
    # Print new  files in b
    foreach my $file (keys %{$rh_b->{'files'}}) {
        push (@{$rh_diff->{'new_files'}}, $file) unless $rh_a->{'files'}->{$file}
    }

    foreach my $file (keys %{$rh_a->{'files'}}) {
        if ($rh_b->{'files'}->{$file} and $rh_a->{'files'}->{$file} ne $rh_b->{'files'}->{$file}) {
		push (@{$rh_diff->{'content'}}, $file ) ;
	  } else {
            push (@{$rh_diff->{'no_change'}}, $file . ':' . $rh_a->{'files'}->{$file} . ':' . $rh_b->{'files'}->{$file} );
        }
    }
    return $rh_diff;
}

sub get_md5_file {
    my ($file) = @_;
    open(my $fh, $file); binmode($fh);
    my $md5 = Digest::MD5->new();
    while(<$fh>) {

	$md5->add($_);
    }
    close($fh);
    return $md5->b64digest();
}
