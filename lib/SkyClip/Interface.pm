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
use HTTP::Request;

sub get_post_data { # data is in request body. can be binary like compressed
    my $q = $CGI->new;
    my ($user,$sign) = map {$q->param($_))||return "Invalid request: param $_ not found"} qw(user sign);
    my ($user_folder) = user_folder $user || return 'Invalid user';
    my ($error,$user_public_key) = read_key($user_folder,'public');
    return $error if $error;
    my $data = $q->param('POSTDATA') || return 'Invalid request: clip body not found';
    return "Invalid clip data/user signature" unless $user_public_key->verify($data, $sign);
    return ($user_folder,$user_data);    
}

=item put_request_data
This sub makes post request consistent with that which get_post_data expects
i.e. it compresses data & crypt it with user public key so only priv key can decrypt this
then it signs it with user priv key in order server can check signature
=cut

sub put_request_data {
    my ($user,$data) = @_;
    my ($error,$user_priv) = read_key(client_path,"private");
    return $error if $error;
    my ($error,$user_public) = read_key(client_path,"public");
    return $error if $error; 
    $data = compress($data);
    $data = $user_public->encrypt($data);
    my $sign = $user_priv->sign($data);
    return (0,HTTP::Request->new("$CLIP_SERVER?user=$user&sign=$sign",,$data));
}