#!/usr/bin/perl -w
use strict;
use warnings;
use Crypt::OpenSSL::RSA;
use File::Slurp qw(write_file);

my $rsa = Crypt::OpenSSL::RSA->generate_key(1024);

my $privkey = 'priv.key';
my $pubkey  = 'public.key';

write_file $privkey,$rsa->get_private_key_string();
print "private key has been written to $privkey\n";

write_file $pubkey, $rsa->get_public_key_string();
print "public key (in PKCS1 format) has been written to $pubkey\n";
   