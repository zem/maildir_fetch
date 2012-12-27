#!/usr/bin/perl
#
use Maildir;
my $dir=$ARGV[0];

$obj=Maildir->new(
	dir=>$ARGV[0]
); 

print join("\n", $obj->ls_msg); 
print "\n";

