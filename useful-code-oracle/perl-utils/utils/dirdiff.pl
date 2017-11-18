
use strict;
use File::Find;
use Data::Dumper;
use Digest::MD5;
use File::Copy qw/copy/;

my $new_ver_dir = $ARGV[1];
my $old_ver_dir = $ARGV[0];
my $file = $ARGV[2] || $ENV{'HOME'}.'/dirdiff.out';
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
