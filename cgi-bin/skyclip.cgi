#!/usr/bin/perl -w
use strict;
use warnings;
use IO::File;
use CGI qw(param);
#use Data::Dumper;
sub debug {	
	my $format = shift(@_)."\n";
	#@_?printf($format,@_):print($format);
}
my %param = map {split /=/} @ARGV;
#debug Dumper(\%param);
$param{$_} = param($_) for param;
#debug Dumper(\%param);
# constants
my $wait_timeout = 60;

# protocol is plain text, first line is current size of $user.dat
print "Content-type: text/plain\n\n";

my ($user,$put,$get,$search) = @param{qw(user put get)};
my $name_dat = "/home/virtwww/w_kharch-org_48bd596b/data/clip/$user.dat";

debug "user=$user";
error("Invalid user") unless -f $name_dat;

debug "put%s",(defined $put?'='.$put:' is undef');
debug "get%s",(defined $get?'='.$get:' is undef');


put_clip($put)  if $put;
get_clips($get) if defined($get);

error("Invalid parameters: don't know what to do.user=user_name;put=text;get=offset!");

sub put_clip { my $clip = shift;
	# open both clip.idx and clip.dat for append, hope it's exclusive operation
	open my $dat_fh,'>>',$name_dat;
	print $dat_fh $clip,"\n";
	close $dat_fh;
	printf "%d\n",-s $name_dat;
	exit 0;
}

sub wait_next_clip { my $cur_size = shift;
	my $try = $wait_timeout;
	while ($cur_size == -s $name_dat && $try--) {
		debug('waiting for input %d',$try+1);
		sleep(1);
	}
	return $try >= 0;
}

sub get_clips { my $offset = shift;
	debug "offset is %s",$offset;
	my $data_size = -s $name_dat;
	debug "data size is %d", $data_size;
	if ($offset >= $data_size) {
		wait_next_clip($data_size);
		$offset = $data_size;
	}
	my $cur_size = -s $name_dat;
	print "$cur_size\n"; # first line of response is always cur size
	exit 0 if $cur_size == $offset;
	open my $dat_fh,"<",$name_dat;seek($dat_fh,$offset,0);
	while (<$dat_fh>) {
		print $_; 
	}
	exit 0;
}

sub error {
	print "Error: $_[0]\n";
	exit 0;
}