package Maildir;
use Sys::Hostname;
use MIME::Base64; 

sub new {
	my ($class, %arg)=@_;
	my $obj=bless(\%arg, $class);


	return $obj;
}

sub get_files {
	my $obj=shift;
	my @files;
	foreach my $dir (@_) {
		opendir(DIR, $obj->{dir}."/".$dir);
		push @files, grep { /^\d+?\..+?\..*$/ } readdir DIR; 
	};
	return @files; 
}

sub mv_cur {
	my $obj=shift;
	foreach my $file ( $obj->get_files("new") ) {
		link($obj->{dir}."/new/".$file, $obj->{dir}."/cur/".$file.":2,") or die "mv_cur: Cant link $file\n";
		unlink($obj->{dir}."/new/".$file) or die "mv_cur: Cant unlink $file\n";
	}
}



########################
## interface


sub ls_msg {
	my $obj=shift; 
	$obj->mv_cur; 
	return $obj->get_files("cur");
}

sub get_msg {
	my $obj=shift; 
	my $dir="cur";
	my $file=shift; 

	open(MAIL, "< $obj->{dir}/$dir/$file") or die "Can't open $obj->{dir}/$dir/$file \n";
	my $buf;
	while(<MAIL>) { $buf.=$_; }
	close MAIL; 

	return $buf; 
}

sub get_msg_b64 {
	my $obj=shift;
	my $file=shift; 
	return encode_base64($obj->get_msg($file));
}

sub del_msg {
	my $obj=shift; 
	my $file=shift; 
	
	#link($obj->{dir}."/cur/".$file, $obj->{dir}."/del/".$file) or die "del_cur: Cant link $file\n";
	unlink("$obj->{dir}/cur/$file") or die "Cant delete message\n";;
}

sub add_msg {
	my $obj=shift;
	my $msg=shift;
	my $dir=$obj->{dir};
	
	$file=time.".".$$.".".hostname;

	open(MAIL, "> $dir/tmp/$file"); 
	print MAIL $msg;
	close MAIL;
	
	link("$dir/tmp/$file", "$dir/new/$file") or  die "Cant link to new mail\n"; 
}

1;
