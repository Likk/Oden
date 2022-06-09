package Oden::API::Universalis;
use strict;
use warnings;

use Furl;
use HTTP::Request::Common;
use JSON::XS qw/decode_json/;
use Time::Piece;

=head1 NAME

  Oden::API::Universalis

=head1 DESCRIPTION

  Oden::API::Universalis web client for universalis.

=cut

=head1 METHODS

=head2 current_data

=head3 parameters

=over

=item B<itemIds>

  required. a list of number(Oden::Model::Item#id)

=item B<world_or_dc>

  required world or dc name

=item B<listings>

  string (query) The number of listings to return. By default, all listings will be returned.

=item B<entries>

  string (query) The number of entries to return. By default, a maximum of 5 entries will be returned.

=item B<no_gst>

  string (query) If the result should not have Gil sales tax (GST) factored in. GST is applied to all consumer purchases in-game, and is separate from the retainer city tax that impacts what sellers receive. By default, GST is factored in. Set this parameter to true or 1 to prevent this.

=item B<hq>

  string (query) Filter for HQ listings and entries. By default, both HQ and NQ listings and entries will be returned.

=item B<stats_within>

  string (query) The amount of time before now to calculate stats over, in milliseconds. By default, this is 7 days.
=item B<entries_within>

  string (query) The amount of time before now to take entries within, in seconds. Negative values will be ignored.

=back

=cut

sub current_data {
    my ($class, $params) = @_;

    my $item_ids    = $params->{item_ids};
    my $world_or_dc = $params->{world_or_dc};

    return unless $item_ids;
    return unless (ref $item_ids eq 'ARRAY');
    return unless ($world_or_dc);

    my $listings        = $params->{listings};
    my $entries         = $params->{entries};
    my $no_gst          = $params->{no_gst};
    my $hq              = $params->{hq};
    my $stats_within    = $params->{stats_within};
    my $entries_within  = $params->{entries_within};

    my $endpoint = sprintf('https://universalis.app/api/v2/%s/%s',
        ($world_or_dc),
        join(',', @$item_ids),
    );

    my $res = $class->_request($endpoint => +{
       $listings     ? ( listings    => $listings       ) : (),
       $entries      ? ( entries     => $entries        ) : (),
       $no_gst       ? ( noGst       => $no_gst         ) : (),
       $hq           ? ( hq          => $hq             ) : (),
       $stats_within ? ( statsWithin => $stats_within   ) : (),
       $stats_within ? ( statsWithin => $entries_within ) : (),
    });

    my @entry = sort {
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
            worldName      => $_->{worldName},
        }
    } @{ $res->{listings} };

    #XXX: might parameterized $entry on current method.
    $#entry = 4 if $#entry > 4;

    my $lastUploadTime = localtime(int($res->{lastUploadTime} /1000))->strftime('%Y/%m/%d %H:%M'); ;
    my $data = +{
        entry => \@entry,
        lastUploadTime => $lastUploadTime,
        #'averagePrice'
        #'averagePriceHQ'
        #'averagePriceNQ'
        #'currentAveragePrice'
        #'currentAveragePriceHQ'
        #'currentAveragePriceNQ'
        #'hqSaleVelocity'
        #'lastUploadTime'
    };
    return $data;
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

L<https://docs.universalis.app/#schema-historymultiviewv2>

=cut

1;
