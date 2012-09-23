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
my $user = get_user_by_email($email);
if ($user) {
    if (get_user_public_key($user) eq $public_key) {
        print "User already created: $user\n";
     } else {
        print "Error: User already registered. If you lost keys/reg info use replace-user.cgi";
     }
     exit 0;
}
my $user = add_user_email($email);

my $text_to_verify = join "\n", $email, $user_pubkey, ;
