#!/usr/bin/perl
use Maildir;

# line length
my $llen=76;
my $hdrname="X-Rcpt-To";

$md=Maildir->new(dir=>shift(@ARGV));

my @ADDRS=@ARGV; 

# handling line breaks for rfc822 is a bit awful 
sub rcpt_hdr {
	my $cutdata=shift; 
	my $hdr="\n	"; 
	my $space=""; 
	if ( ! $cutdata ) { 
		$hdr=$hdrname.": "; 
	} else {
		@ADDRS=($cutdata, @ADDRS); 
	}
	# für jede adresse im parameter 
	while ( my $addr=shift(@ADDRS) ) {
		#auf überlänge prüfen
		#print length($hdr.$space.$addr)." ".$llen."\n";
		if (length($hdr.$space.$addr) >= $llen) {
			# ok lets linebreak this we have two cases
			if ( ($hdr eq $hdrname) or ($hdr eq "\n	")) {
				# data cant be splitted
				# but this will never happen but it could 
				#print "superlongline $hdr -- $addr \n";
				$hdr=$hdr.$space.$addr; 
				$hdr=substr($hdr, 0, $llen).rcpt_hdr(substr($hdr, $llen));
			} else {
				# data can be splitted so we will make 
				# a linebreak
				#print "longline $hdr -- $addr \n";
				$hdr=$hdr.$space.rcpt_hdr($addr); 
			}
		} else {
			#print "data $addr \n";
			$hdr=$hdr.$space.$addr; 
		}
		$space=" ";
	}
	print $hdr."\n";
	return $hdr;
}

my $msg='';
while(<STDIN>){ $msg.=$_; }

if ( ! $msg ) { die "No Message on stdin\n"; }
$md->add_msg(rcpt_hdr()."\n".$msg);

