#!/usr/bin/perl

use FileHandle;
use IPC::Open2; 
use MIME::Base64; 
use IO::Handle;

my $procmail=procmail; 
my $srv="./md_srv.pl"; 
my $host=$ARGV[0];
$host=~s/:.*$//g; 
my $dir=$ARGV[0];
$dir=~s/^.*://g; 

my $pid=open2("DATA", "CMD", "ssh", $host, $srv." ".$dir) or die "Cant connect to server\n";
print "Chld Pid $pid\n";

sub get_data {
	my $buf;
	while (<DATA>) {
		if ( /^READY/ ) {
			chomp($buf);
			return $buf;
		}
		$buf.=$_;
	}
	print $buf; 
	exit; 
}

print get_data."\n";

print CMD "LST\n"; 
foreach my $msg (split(/\n/, get_data)) {
	print "Fetching $msg \n"; 
	print CMD "GET $msg\n";
	open (PROC, "| procmail ") or die "cant call procmail\n"; 
	print PROC decode_base64(get_data);
	close PROC; 
	print "Delete $msg \n"; 
	print CMD "DEL $msg\n";
	get_data;
}

print CMD "QUIT\n"; 
print get_data."\n";

close CMD;
close DATA;


