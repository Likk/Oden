package Oden::API::Xivapi;
use strict;
use warnings;

use Furl;
use HTTP::Request::Common;
use JSON::XS qw/decode_json/;

=head1 NAME

  Oden::API::Xivapi

=head1 DESCRIPTION

  Oden::API::Xivapi web client for xivapi.com.

=cut

our $BASE_URL = 'https://xivapi.com';

=head1 METHODS

=head2 linkshell_profile

=cut

sub linkshell_profile {
    my ($class, $loadstone_id, $crossworld) = @_;
    my $endpoint_path = $crossworld ? 'linkshell/crossworld' : 'linkshell';
    my $res = $class->_request(sprintf("%s/%s/%s", $BASE_URL, $endpoint_path, $loadstone_id));
}

=head1 PRIVATE METHODS

=head2 _request

  request and response interface.

=cut

sub _request {
    my ($class, $endpoint, $params) = @_;

    my $req = HTTP::Request->new('GET' => $endpoint,
        [],
        $params,
    );
    my $res = $class->_user_agent->request($req);

    my $data;
    unless($res->is_success()){
        warn $res->status_line;
    }
    eval {
        $data = decode_json($res->decoded_content());
    };
    if($@){
        my $e = $@;
        warn $e;
    }
    return $data;
}

=head2 _user_agent

  create furl object and return.

=cut

sub _user_agent {
    my $class = shift;
    my $furl = Furl->new(
        agent   => 'Oden bot client github.com/Likk/Oden',
        timeout => 10,
    );
    return $furl;
}

=head1 SEE ALSO

L<https://xivapi.com/docs>

=cut

1;
