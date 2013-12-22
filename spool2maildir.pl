#!/usr/bin/perl
use Maildir;

# line length
my $llen=76;
my $hdrname="X-Rcpt-To:"

$md=Maildir->new(dir=>shift(@ARGV));

# handling line breaks for rfc822 is a bit awful 
sub rcpt_hdr {
	my $cutdata=shift; 
	my $hdr="\n	"; 
	if ( ! $cutdata ) { $hdr=$hdrname; }
	while ( my $addr=shift(@ARGV) ) {
		if (length($hdr." ".$addr) >= $llen) {
			# ok lets linebreak this we have two cases 
			if ($hdr==$hdrname) {
				# data cant be splitted
				# but this will never happen but it could 
				$hdr=$hdr." ".$addr; 
				$hdr=substr($hdr, 0, $llen).rcpt_hdr(substr($hdr, $llen));
			} else {
				# data can be splitted so we will make 
				# a linebreak
				$hdr=$hdr." ".rcpt_hdr(substr($addr); 
			}
		}
	}
	return $hdr."\n";
}

my $msg='';
while(<STDIN>){ $msg.=$_; }

if ( ! $msg ) { die "No Message on stdin\n"; }
$md->add_msg(rcpt_hdr().$msg);

