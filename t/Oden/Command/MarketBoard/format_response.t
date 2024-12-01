use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::MarketBoard;

describe 'about Oden::Command::MarketBoard#format_response' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case no parametor' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    Oden::Command::MarketBoard->format_response();
                };

                like $throws, qr/Too few arguments for fun format_response/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case message is "zeromus Lalafellin Kaftan"' => sub {
            before_all "setup market records" => sub {
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

done_testing;
