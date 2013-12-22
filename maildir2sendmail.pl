#!/usr/bin/perl
use Maildir;

my $sendmail="/usr/lib/sendmail -oi -oem"; 
my $hdrname="X-Rcpt-To";
my $box=shift(@ARGV);
$md=Maildir->new(dir=>$box);

foreach my $msg ($md->ls_msg) {
	open(MSG, "< $box/cur/$msg") or die "Can't open message $msg\n"; 
	my $head=1;
	my $msgdata;
	my $rcptostr;
	#my @rcpto; 
	my $rcptocompl=0; 
	while (<MSG>){
		if ( $head ) {
			if ( substr($_,0,length($hdrname.": ")) eq $hdrname.": " )  {
				# fount the RCPT To Header 
				$rcptostr.=substr($_,length($hdrname.": "));
				chomp($rcptostr); 				
			} elsif (
				( $rcptocompl==0) and 
				($rcptostr) and
				(substr($_, 0, 1) eq "	")
			) {
				# we have a multilineheader 
				$rcptostr.=substr($_,1);
				chomp($rcptostr); 				
			} elsif (
				($rcptocompl==0) and 
				($rcptostr) and
				(substr($_, 0, 1) ne "	")
			) {
				#rcpt to header is now complete
				$rcptocompl=1; 
				#@rcpto=split(" ", $rcptostr); 
				# we are also not interested in parsing more head 
				$head=0; 
				$msgdata.=$_;
			} else {
				if ( $_ = "\n" ) { 
					$head=0; 
				}  # body reached 
				$msgdata.=$_;
			}
		} else {
			$msgdata.=$_; 
		}
	}
	close(MSG); 

	# now we do sanity checks 
	if ( ( ! $msgdata ) or ( ! $rcptostr )) { die "oops empty message or no one to send to \n"; }
	
	print "open $sendmail $rcptostr\n"; 
	open(SEND, "> dummy") or die "cant send message\n"; 
	print SEND $msgdata or die "Sending of message Failed error writing to pipe\n";
	close SEND or die "closing of sendmail utility failes \n";  
	
	print  "$md -> del_msg($msg) \n" ; 
}
