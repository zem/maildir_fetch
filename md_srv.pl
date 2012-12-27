#!/usr/bin/perl

use FileHandle;
STDOUT->autoflush(1);
use Maildir;

my $md=Maildir->new(dir=>$ARGV[0]);

print "READY\n"; 
while (<STDIN>)  {
	chomp;
	if ( /^DEL .+$/ ) {
		s/^DEL //g;
		$md->del_msg($_);
	} elsif ( /^QUIT$/ ) {
		print "BYE\n"; 
		exit; 
	} elsif ( /^LST$/ ) {
		print join("\n", $md->ls_msg)."\n";
	} elsif ( /^GET .+$/ ) {
		s/^GET //g;
		print $md->get_msg_b64($_);
	}
	print "READY\n"; 
}
