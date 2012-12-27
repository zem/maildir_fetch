#!/usr/bin/perl
#
use Maildir;
my $dir=$ARGV[0];

$obj=Maildir->new(
	dir=>$ARGV[0]
); 

print $obj->get_msg($ARGV[1]); 


