package Oden::API::Universalis;
use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;
use Furl;
use HTTP::Request::Common;
use JSON::XS qw/decode_json/;
use Time::Piece;
use Types::Standard -types;

=head1 NAME

  Oden::API::Universalis

=head1 DESCRIPTION

  Oden::API::Universalis web client for universalis.

=cut

=head1 METHODS

=head2 current_data

=head3 parameters

=head4 required

=over

=item B<item_ids>

  required. a list of number(Oden::Model::Item#id)

=item B<world_or_dc>

  required world or dc name

=back

=head4 optional

=over

=item B<max_records>

  interger. The number of records to return.
    default: a maximum of 5 records will be returned.

=item B<listings>

  string (query) The number of listings to return. By default, all listings will be returned.

=item B<entries>

  string (query) The number of entries to return. By default, a maximum of 5 entries will be returned.

=item B<no_gst>

  string (query) If the result should not have Gil sales tax (GST) factored in. GST is applied to all consumer purchases in-game, and is separate from the retainer city tax that impacts what sellers receive. By default, GST is factored in. Set this parameter to true or 1 to prevent this.

=item B<is_high_quality>

  string (query) Filter for "high quality" listings and entries. By default, both high quality and not high quality listings and entries will be returned.

=item B<stats_within>

  string (query) The amount of time before now to calculate stats over, in milliseconds. By default, this is 7 days.

=item B<entries_within>

  string (query) The amount of time before now to take entries within, in seconds. Negative values will be ignored.

=back

=cut

fun current_data(ClassName $class, HashRef $params) :Return(Maybe[HashRef]){
    my $item_ids    = $params->{item_ids};
    my $world_or_dc = $params->{world_or_dc};
    my $max_records = $params->{max_records} || 5;

    return undef unless $item_ids;
    return undef unless (ref $item_ids eq 'ARRAY');
    return undef unless ($world_or_dc);

    my $listings        = $params->{listings};
    my $entries         = $params->{entries};
    my $no_gst          = $params->{no_gst};
    my $is_high_quality = $params->{is_high_quality};
    my $stats_within    = $params->{stats_within};
    my $entries_within  = $params->{entries_within};

    my $endpoint = sprintf('https://universalis.app/api/v2/%s/%s',
        ($world_or_dc),
        join(',', @$item_ids),
    );

    my $res = $class->_request($endpoint => +{
       $listings        ? ( listings    => $listings        ) : (),
       $entries         ? ( entries     => $entries         ) : (),
       $no_gst          ? ( noGst       => $no_gst          ) : (),
       $is_high_quality ? ( hq          => $is_high_quality ) : (),
       $stats_within    ? ( statsWithin => $stats_within    ) : (),
       $stats_within    ? ( statsWithin => $entries_within  ) : (),
    });

    return undef unless $res;

    my @records = sort {
        $a->{pricePerUnit} <=> $b->{pricePerUnit},
    }
    map {
        +{
            onMannequin    => $_->{onMannequin} ? 1 : 0,
            lastReviewTime => $_->{lastReviewTime},
            pricePerUnit   => $_->{pricePerUnit},
            quantity       => $_->{quantity},
            retainerCity   => $_->{retainerCity},
            total          => $_->{total},
            hq             => $_->{hq} ? 1 : 0,
            worldName      => $_->{worldName} || $res->{worldName}, #case In world search when world_name is not set at listings.
        }
    } @{ $res->{listings} };

    $#records = $max_records - 1 if $max_records < $#records;

    my $lastUploadTime = localtime(int($res->{lastUploadTime} /1000))->strftime('%Y/%m/%d %H:%M'); ;
    my $data = +{
        records => \@records,
        lastUploadTime => $lastUploadTime,
    };
    return $data;
}

=head1 PRIVATE METHODS

=head2 _request

  request and response interface.

=cut

sub _request {
    my ($class, $endpoint, $params) = @_;


    my $url = URI->new($endpoint);
    $url->query_form(%$params);

    my $req = HTTP::Request->new('GET' => $url->as_string);
    my $res = $class->_user_agent->request($req);

    my $data;
    unless($res->is_success()){
        warn $res->status;
        warn $res->message;
        return;
    }
    try {
        $data = decode_json($res->decoded_content());
    }
    catch ($e) {
        warn $e;
        return;
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

L<https://docs.universalis.app/#schema-historymultiviewv2>

=cut

1;
