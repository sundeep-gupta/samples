#!/usr/bin/perl
use CGI;
use CGI::Carp qw(fatalsToBrowser);
print "Content-type: text/html\n\n";

my $q=CGI->new;
my $resultsloc=$q->param("resultloc");
if(defined($q->param("resultloc")))
{
	my $totalxml="$resultsloc/total.xml";
	use XML::Simple;
	my $xml = new XML::Simple;
	print "<style>
.tblborder {
border:1px solid #dddddd !important;
padding:0px;
margin:0px;
color: #000000;
font-size:13px;
font-family: Arial, Tahoma, Verdana;
} 
.tblborder >tbody > tr > th{
 text-align:center;
 margin:0px;
}
.tblborder_inner
{
	width:100%;
}
.tblborder >tbody > tr > td, .tblborder >tbody > tr > th 
{
padding:2px;
border:1px solid #dddddd !important;
}
table, td, th{
padding:2px;
margin:0px;
border:1px solid #dddddd;
background-color:transparent;
}

</style>";
	if(! -f $totalxml)
	{
		print "<html><body><h2>Sorry!!!</h2>Cannot process triage now. <br> 1.If the farm job is running please wait for the completion.<br>2. Or check if the results location is available</body></html>";
		exit;
	}
	print "<html><body>";
	$farmobj = $xml->XMLin("$totalxml") || die ("Cannot read $totalxml. Error: $!");
	print "<table class='tblborder' cellspacing=0 cellpadding=0 >
	<tr>
		<th>LRG</th>
		<th>Suc</th>
		<th>Dif</th>
		<th>Fileinfo</th>
	</tr>";
	my $lrglist=$farmobj->{lrg};	
	my @user_lrglist;
	if(defined($q->param("lrglist")))
	{
		my $user_lrg=$q->param("lrglist");
		@user_lrglist=split(/,/,$user_lrg);		
	}
	my $total_lrg_match=0;
	my @list_of_lrgs;
	if(ref($lrglist)=~/HASH/i)
	{
		@list_of_lrgs=($lrglist);
	}else{
		@list_of_lrgs=@$lrglist;
	}
	
	foreach my $lrg (@list_of_lrgs)
	{
	    my $bgcolor="#affea7";
		$bgcolor="#ff9595" if($lrg->{diffcnt}->{count}>0);
		if(scalar(@user_lrglist)!=0)
		{
		  
		  my $lrgmatch=0;
		  foreach my $user_lrgname(@user_lrglist)
		  {
		    	#print "$user_lrgname: ".$lrg->{lrgname}."<br>";
			my $user_lrgname_like=$user_lrgname;
			if($user_lrgname=~/%/)
			{
				$user_lrgname_like=~s/%/\.\*/i;				
			}
			my $curr_lrg=$lrg->{lrgname};
			if($curr_lrg=~/^$user_lrgname_like$/i)
			{
			   $lrgmatch++;
			   last;
			}
		  }
		  next if($lrgmatch==0); # Process next if no match found
		}
		$total_lrg_match++;
		print "<tr style=\"background-color:$bgcolor\">";
		print "<td>".$lrg->{lrgname}."</td>";
		print "<td>".$lrg->{succnt}."</td>";
		print "<td>".$lrg->{diffcnt}->{count}."</td>";
		print "<td>";
		if($lrg->{diffcnt}->{count}>0 && exists($lrg->{diffcnt}->{difflog}))
		{
			#print "<table class='tblborder_inner' cellspacing=0 cellpadding=0>";
			my $difflog_hash=$lrg->{diffcnt}->{difflog};
			foreach my $difflogname ( keys %$difflog_hash)
			{
				my $zipfile =get_file_ext_as($difflog_hash->{$difflogname}->{href},"zip");
				#print "<tr><td><a target='_blank' href=\"triagefarm.pl?type=dif&file=".$difflog_hash->{$difflogname}->{href}."\">$difflogname</a></td>";
				if ( -f $difflog_hash->{$difflogname}->{href} && -r $difflog_hash->{$difflogname}->{href} )
				{ 
					print "<a target='dif_details' href=\"/cgi/triagefarm.pl?type=dif&file=".$difflog_hash->{$difflogname}->{href}."\">$difflogname</a>";
				}else #check if there are files with name filename*.dif
				{
					use File::Basename;
					my $file_basename=$difflog_hash->{$difflogname}->{href};
					$file_basename=~s/(.*)\.dif$/$1/i;
					#print "$file_basename - $difflog_hash->{$difflogname}->{href}";
					my @files_list_with_basename=`ls $file_basename*.dif`;
					#print $file_basename;
					foreach my $curr_dif_file(@files_list_with_basename)
					{
						my $curr_filename_only=basename($curr_dif_file);
						print "<a target='dif_details' href=\"/cgi/triagefarm.pl?type=dif&file=".$curr_dif_file."\">$curr_filename_only</a>";
						my $zipfile =get_file_ext_as($curr_dif_file,"zip");
						if( -f $zipfile & -r $zipfile )
						{
							print "(<a target='_blank' href=\"/cgi/triagefarm.pl?type=zip&file=".$curr_dif_file."\"><img border=0 src='screenshot.gif' /></a>)";
						}
						print ", &nbsp;";
					}
					print $difflogname if(!scalar(@files_list_with_basename));					
				}
				if(!($difflogname=~/watson\.dif\s*$/||$difflogname=~/\.tlg\s*$/ ) && -f $zipfile & -r $zipfile )
				{
					print "(<a target='_blank' href=\"/cgi/triagefarm.pl?type=zip&file=".$difflog_hash->{$difflogname}->{href}."\"><img border=0 src='screenshot.gif' /></a>)";
				}
				print ", &nbsp;";
				#print "</td></tr>";
			}
			#print "</table>";
		}else{print "&nbsp;";}
		print "</td>";
		print "</tr>";
	}
	if($total_lrg_match==0)
	{
	  print "<tr><td colspan=4>No lrgname match found</td></tr>";
	}
	print "</table>";
	exit;
}
#----------- EOF Results Location -----------------

print "<html>
<head>
<style>
body,table,tr,td,th{
font-family: Arial, Verdana, Tahoma;
font-size: 12px;
color: #000000;
padding:2px;
margin:0px;
}
pre{
font-size: 13px;
border:1px solid #dddddd;
background-color: #f2f2f2;
padding:5px;
}
</style>
</head>
<body>";

#------------ Start dif/zip File Parser -----------------
my $inputfile=$q->param("file");
my $filetype=$q->param("type");
my $exist_dir;
$exist_dir=$q->param("dir") if(defined($q->param("dir")));

# Get the zipfilename
my $diffile=get_file_ext_as($inputfile,"dif");
my $zipfile=get_file_ext_as($inputfile,"zip");
my $logfile=get_file_ext_as($inputfile,"log");
my $htmlfile=get_file_ext_as($inputfile,"html");
my $errfile=get_file_ext_as($inputfile,"err.log");
my $file_no_ext=get_basename_no_ext($inputfile);

# Exit if the file is not readable 
if (!(-f $inputfile &&  -r $inputfile))
{
  print "File $inputfile not found or not readable\n";
  exit ;
}
print "<script> function load_page(type) 
{
	window.location.href='/cgi/triagefarm.pl?type='+type+'&file=".$inputfile."';  
}</script>";
print "<input type='button' value=\"Screenshots\" onclick='load_page(\"zip\")'/>" if( -f $zipfile && -r $zipfile && ($filetype ne "zip" ));
print "<input type='button' value=\"Dif\" onclick='load_page(\"dif\")'/>" if( -f $diffile && -r $diffile && ($filetype ne "dif"));
print "<input type='button' value=\"Log\" onclick='load_page(\"log\")'/>" if( -f $logfile && -r $logfile && ($filetype ne "log"));
print "<input type='button' value=\"Error\" onclick='load_page(\"err\")'/>" if( -f $errfile && -r $errfile && ($filetype ne "err"));
print "<input type='button' value=\"Html\" onclick='load_page(\"html\")'/>" if( -f $htmlfile && -r $htmlfile && ($filetype ne "html"));
#------------------------------------------------
# Define search
#------------------------------------------------
my $search_dir;
use File::Find ();
# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;
sub pngwanted {
    my($filename)=@_;
    /^.*\.png\z/si
    && print("$name\n");
}
sub dirwanted{
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    /^$file_no_ext\z/s &&
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -d _
    && ($search_dir=$name);
}
#------------------------------------------------

if ($filetype=~/zip/i && -f $zipfile && -r $zipfile)  # If zip file exists then process
{
  my $tmpdir="/var/www/farmstatus/htdocs/triage/tmp/";
  my $httpdir="/triage/tmp/";
  if(!$exist_dir) # to use cached files 
  {
	$exist_dir=$$;
    	my @unzipoutput=`unzip $zipfile -d $tmpdir/$exist_dir`;
  	#print @unzipoutput;
	#chdir "$tmpdir/$$";
  	#opendir(MYDIR, "$tmpdir/$$")||die("cannot read dir");
  }
  #print "<pre>";
  File::Find::find({wanted => \&dirwanted,bydepth=>1}, "$tmpdir/$exist_dir");
  #print "search_dir:".$search_dir.":\n";
  if($search_dir=~/^\s*$/)
  {
	print "<h2>Sorry!</h2> Looks the <b>$zipfile </b> doesnot contain any screenshot. Might not be a selenium zip";
	print "</body></html>";
	exit;
  }
  opendir my $dh, "$search_dir" or die "$search_dir $!";
  my @files = grep /png$/i, readdir $dh;
  #print $files[0]."\n".(-M "$search_dir/".$files[0]);
  my @sorted = sort { -M $search_dir."/".$b <=> -M $search_dir."/".$a } @files;
  #print @sorted;
  #print $search_dir;
  #print "</pre>\n";
  print "<script> var i=1;</script>";
  print "<script>\nvar image_array=new Array();\n ";
  my $icount=0;
  foreach $pngfile (@sorted)
  {
    next if ($pngfile=~/^\/\.$/ || $pngfile=~/^\/\.\.$/);
	next if (!$pngfile=~/png$/i);
    my $image_dir=$search_dir;
    $image_dir=~s/$tmpdir/$httpdir/;
    my $imgpath=$image_dir."/".$pngfile;
    $imgpath=~s/\/\/*/\//;
    print "image_array[$icount]=\"$imgpath\";\n";
    $icount++;
  }
  print "
function next_image()
{
	i++ ;
	set_image();
}
function buttons_enable_disable()
{
	if(i==1)
	{
		document.getElementById('previous_btn').disabled=true;
		document.getElementById('first_btn').disabled=true;
	}else{
		document.getElementById('previous_btn').disabled=false;
		document.getElementById('first_btn').disabled=false;
	}
	if(image_array.length>(i))
	{
		document.getElementById('next_btn').disabled=false;
		document.getElementById('last_btn').disabled=false;
	}else{
		document.getElementById('next_btn').disabled=true
		document.getElementById('last_btn').disabled=true;
	}
}
function previous_image()
{
	if(i>0)
	{
 		i--;
		set_image();
	}
}
function first_image()
{
	i=1;
	set_image();
}
function last_image()
{
	i=image_array.length;
	set_image();
}
function set_image()
{
	document.getElementById('screenshot').src=image_array[i-1];
	document.getElementById('cur_img_num').value=i;
        buttons_enable_disable();
}
function goto_image(goto)
{
	if(isNaN(goto))
 	{
		alert('Please enter valid number');
	}else{
		if(goto>0 && goto<=image_array.length )
		{
			i=goto;
			set_image();
		}else{
			alert('Please enter value within ' + image_array.length);
		}
	}
}
</script>
<button id='first_btn' onclick='first_image()'>&lt;&lt;</button>\n
<button id='previous_btn' onclick='previous_image()'>&lt;</button>\n
<button id='next_btn' onclick='next_image()'>&gt;</button>\n
<button id='last_btn' onclick='last_image()'>&gt;&gt;</button>\n
<input id='cur_img_num' maxlength=4 size=5 value='0' /> of <label id='image_count'></label> <button id='goto_img_num' onclick='javascript:goto_image(document.getElementById(\"cur_img_num\").value)'>Go</button><br>
<img id='screenshot' src=\"\"/><br>\n
<script>
document.getElementById('image_count').innerHTML=image_array.length;
set_image();
</script>\n
\n";

}elsif($filetype=~/log/i){
	if(-f $logfile && -r $logfile )
	{
		open(DIFFILE,$logfile) || die("Cannot open file: $logfile ; error : $!");
		print "<b> Filename: $logfile</b><br>";
		my @difcontent=<DIFFILE>;
		print "<pre>";
		print @difcontent;
		print "</pre>";
	}else{
		print "Log filename $logfile doesnot exist<br>";
	}
}elsif($filetype=~/err/i)
{
	if(-f $errfile && -r $errfile )
	{
		open(DIFFILE,$errfile) || die("Cannot open file: $errfile ; error : $!");
		my @difcontent=<DIFFILE>;
		print "<b> Filename: $errfile</b><br>";
		print "<pre>";
		print @difcontent;
		print "</pre>";
	}else{
		print "Error filename $errfile doesnot exist<br>";
	}
}elsif($filetype=~/html/i)
{
	if(-f $htmlfile && -r $htmlfile )
	{
		open(DIFFILE,$htmlfile) || die("Cannot open file: $htmlfile ; error : $!");
		my @difcontent=<DIFFILE>;
		print "<b> Filename: $htmlfile</b><br>";
		print "<div>";
		print @difcontent;
		print "</div>";
	}else{
		print "html filename $htmlfile doesnot exist<br>";
	}
}elsif($filetype=~/dif/i || $filetype=~/tlg/i)
{
	if(-f $inputfile && -r $inputfile )
	{
		open(DIFFILE,$inputfile) || die("Cannot open file: $inputfile ; error : $!");
		my @difcontent=<DIFFILE>;
		print "<b> Filename: $inputfile</b><br>";
		print "<pre>";
		print @difcontent;
		print "</pre>";
	}else{
		print "Log filename $inputfile doesnot exist<br>";
	}
}else
{
	print "Sorry !!! Filetype $filetype not supported<br>";
}
print "</body></html>";

#-------------------------
# Functions
#-------------------------
sub get_file_ext_as
{
	my($filename,$ext)=@_;
	$filename=~s/(.*)\....\s*$/$1.$ext/i;
	return $filename;
}
#-------------------------------------------------------
# Process the file name (dif to zip if present)
# Extract filename
#-------------------------------------------------------
sub get_basename_no_ext
{
	my ($filename)=@_;	
	use File::Basename;
	my $filenameonly=basename($filename);
	my ($file_without_ext)=($filenameonly=~/(.*)\..*$/i);
	return $file_without_ext;
}
#-------------------------------------------------------
