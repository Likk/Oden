package Oden::API::LodestoneNews;
use strict;
use warnings;

use Furl;
use HTTP::Request::Common;
use JSON::XS qw/decode_json/;

=head1 NAME

  Oden::API::LodestoneNews

=head1 DESCRIPTION

  Oden::API::LodestoneNews web client for lodestonenews.com.

=cut

our $BASE_URL = 'https://lodestonenews.com';

=head1 METHODS

=head2 linkshell_profile

=cut

sub list {
    my ($class, $category, $locale, $limit) = @_;
    $category ||= 'all';
    $locale   ||= 'na';
    $limit    ||= 20;
    my $res = $class->_request(sprintf("%s/news/%s?locale=%s&limit=%s",
        $BASE_URL,
        $category,
        $locale,
        $limit
    ));
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

L<https://documenter.getpostman.com/view/1779678/TzXzDHVk>
L<github.com/mattantonelli/lodestone-sinatra>

=cut

1;
