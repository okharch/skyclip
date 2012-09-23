#!/usr/bin/perl -w
use strict;
use warnings;
use IO::File;
use CGI;
use lib '.';
my $q = CGI->new;;
#use Data::Dumper;
sub debug {	
	my $format = shift(@_)."\n";
	#@_?printf($format,@_):print($format);
}
print "Content-type: text/plain\n\n";
my ($email,$public_key,$sign) = map $q->param($_) || error('Invalid request'), qw(email user_pubkey sign);
my $text_to_verify = join "\n", $email, $user_pubkey, $sign, read_file("$app_data/$server_pub_key");
