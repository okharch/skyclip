package SkyClip::Const;
my $global_constants;
BEGIN {
    my $dd = '/home/virtwww/w_kharch-org_48bd596b/data/skyclip';
    $global_constants = {
        SERVER_DIR  => "$dd/server",
        SERVER_PRIVKEY => "$dd/server/skyclip-priv.key",
        SERVER_PUBKEY => "$dd/server/skyclip-pub.key",
        USER_DIR    => "$dd/user", 
        TXT_HEADER => "Content-type: text/plain\n\n",
    };
    $global_constants{USER_DATA_DIR} 
};
use constant $global_constants;
use base 'Exporter';

sub user_folder { my $user = shift;
    return USER_DIR . "/$user";
}

sub error {
    my $error = shift;
    print "Error: $error\n";
    exit 0;
}
our @EXPORT = keys(%$global_constants),qw(server_pubkey error);
