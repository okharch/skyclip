package SkyClip::Interface;
use SkyClip::Const;
use File::Slurp qw(read_file);
use Digest::SHA1 qw(sha1_base64);
use Compress::Zlib;
use CGI;
use MIME::Base64;
use XML::Simple;
use base 'Exporter';
our @EXPORT=qw(request response header);
use const header => "Content-type: application/xml";

sub get_post_data { # data is in request body. can be binary like compressed
    my $q = $CGI->new;
    my ($user,$sign) = map {$q->param($_))||return "Invalid request: param $_ not found"} qw(user sign);
    $user =~ s/[^a-z0-9]//g; # remove dangerous symbols from user param
    my $user_folder = USER_DIR . "/$user";
    my $user_public_key = check_sign($data,$sign,"$user_folder/public.key";
    $user_public_key = read_file($user_public_key) || return "User public key not found";
    my $user_rsa = $rsa->new_public_key($user_public_key) || return "Invalid user public key";
    my $data = $q->param('POSTDATA') || return 'Invalid request: clip body not found';
    return "Invalid clip data/user signature" unless $rsa->verify($data, $sign);
    return {user_folder=> $user_folder,user_data => $user_data};    
}

sub put_request_data {
    my $data = shift;
    my $user = $
    $data = compress($data);
    
}