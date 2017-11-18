#!/usr/bin/perl
my $cleanup_dir="/var/www/farmstatus/htdocs/triage/tmp";
opendir my $dh, "$cleanup_dir" or die "File $cleanup_dir not found. Error: $!";
my @dirlist = grep /^[0-9]*$/i, readdir $dh;
foreach my $curr_dir (@dirlist)
{
	$curr_dir="$cleanup_dir/$curr_dir";
	my $dir_mod_min=( -M $curr_dir) * 24 * 60;
	print "curr_dir = $curr_dir -> $dir_mod_min : ".(-M  $curr_dir)."\n";
	if ($dir_mod_min > 10)
	{
		print "Cleaning up directory: $curr_dir\n";
		print `rm -rf  $curr_dir`;
		print "Done cleaning up directory: $curr_dir\n";
	}
}
