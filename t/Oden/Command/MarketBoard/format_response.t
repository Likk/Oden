use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::MarketBoard;

describe 'about Oden::Command::MarketBoard#format_response' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case no parametor' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::MarketBoard->format_response();
                } qr/Too few arguments for fun format_response/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case message is "zeromus Lalafellin Kaftan"' => sub {
            before all => sub {
                my $res = +{
                    'records' => [
                        +{
                            'hq'             => 0,
                            'lastReviewTime' => 1377590400,
                            'onMannequin'    => 0,
                            'pricePerUnit'   => 8000,
                            'quantity'       => 1,
                            'retainerCity'   => 7,
                            'total'          => 8000,
                            'worldName'      => 'Ifrit',
                        },
                        +{

                            'hq'             => 1,
                            'lastReviewTime' => 1377590400,
                            'onMannequin'    => 0,
                            'pricePerUnit'   => 8999,
                            'quantity'       => 1,
                            'retainerCity'   => 2,
                            'total'          => 8999,
                            'worldName'      => 'Pandaemonium'
                        },
                    ],
                    'lastUploadTime' => '2013/08/27 17:00',
                };
                $hash->{res} = $res;
            };

            it 'when returns ' => sub {
                my $response = Oden::Command::MarketBoard->format_response($hash->{res});
                is $response, <<'EOT', 'response is expected';
last update: 2013/08/27 17:00

`Ifrit        : Gil      8,000 x   1`
`Pandaemonium : Gil      8,999 x   1` <:hq:983319334476742676>
EOT
            };
        };
    };

};

runtests;
