package Oden::API::LodestoneNews;
use 5.40.0;
use feature 'try';

use Function::Parameters;
use Function::Return;
use Furl;
use HTTP::Request::Common;
use JSON::XS qw/decode_json/;
use Types::Standard -types;

=head1 NAME

  Oden::API::LodestoneNews

=head1 DESCRIPTION

  Oden::API::LodestoneNews web client for lodestonenews.com.

=cut

our $BASE_URL = 'https://lodestonenews.com';

=head1 METHODS

=head2 list

  request and collect information about news.

  Parameters:
    Str :$category default 'all'
      'topics'. 'notices', 'maintenance', 'updates', 'status', 'developers' and 'all'.
    Str :$locale default 'na'
      'na', 'eu', 'fr', 'de', 'jp'.
    Int :$limit default 20
      1 to 20.

  Returns:
    HashRef: {
        "$category" => [
            {
                "id"          => "string",
                "url"         => "string",
                "title"       => "string",
                "time"        => "YYYY-MM-DDTHH:MM:SSZ",
                "img"         => "string",
                "description" => "string"
            }
        ]
    }

=cut

fun list(ClassName $class, Str $category = 'all', Str $locale = 'na', Int $limit = 20) :Return(HashRef) {
    my $res = $class->_request(sprintf("%s/news/%s?locale=%s&limit=%s",
        $BASE_URL,
        $category,
        $locale,
        $limit
    ));

    # $res structure of the hashref is different $category value.
    #   'all' and any (topics, notices, maintenance, updates, status, developers), so it is adjusted to all.
    return $category eq 'all' ? $res : +{ $category => $res };
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

    unless($res->is_success()){
        warn $res->status_line;
        return +{};
    }

    try {
        return decode_json($res->decoded_content());
    }
    catch ($e){
        warn $e;
        return +{};
    }
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
