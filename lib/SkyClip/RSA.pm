package SkyClip::RSA;
use strict;
use warnings;
use SkyClip::Const;
use Crypt::OpenSSL::RSA;
use File::Slurp qw(read_file);
use base 'Exporter';
our @EXPORT = qw(check_sign server_public_key user_public_key);

my $rsa = "Crypt::OpenSSL::RSA";
sub check_sign { my ($data,$sign,$public_key) = @_;
    my $cs = $rsa->new_public_key($public_key) || error("Invalid public key");
    $rsa->verify($data, $sign) || error("Invalid data/sign");
}

sub server_public_key {
    read_file(SERVER_PUBKEY) || error("Can't load load server public key");
}

sub user_public_key { my $user = shift;
    read_file(user_folder($user)."/public.key") || error("Can't read user public key");
}

1;