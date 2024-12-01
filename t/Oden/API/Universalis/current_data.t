use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::API::Universalis;

describe 'about Oden::API::Universalis#current_data' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case no parameter' => sub {
            it 'when no parameter' => sub {
                my $throws_ok = dies {
                    my $res = Oden::API::Universalis->current_data();
                };
                like $throws_ok, qr/Too few arguments for fun current_data/, 'no parameter';
            };
        };
        describe 'required parameter' => sub {
            describe 'case no item_ids' => sub {
                it 'when no item_ids' => sub {
                    my $res = Oden::API::Universalis->current_data(+{
                        world_or_dc => 'zeromus',
                    });
                    is $res, undef, 'no item_ids';
                };
            };
            describe 'case no world_or_dc' => sub {
                it 'when no world_or_dc' => sub {
                    my $res = Oden::API::Universalis->current_data(+{
                        item_ids => [36213],
                    });
                    is $res, undef, 'no world_or_dc';
                };
            };
            describe 'case item_ids is not arrayref' => sub {
                it 'when item_ids is not arrayref' => sub {
                    my $res = Oden::API::Universalis->current_data(+{
                        item_ids    => 36213,
                        world_or_dc => 'zeromus',
                    });
                    is $res, undef, 'item_ids is not arrayref';
                };
            };
        };
    };

    describe "Positive testing" => sub {
        before_all "setup" => sub {
            $hash->{world_or_dc} = 'zeromus';
            $hash->{mocks} = mock "Oden::API::Universalis" => (
                override => [
                    _request => sub {
                        return +{
                            lastUploadTime => time(),
                            listings       => [{
                                lastReviewTime => time(),
                                pricePerUnit   => 300,
                                quantity       => 1,
                                stainID        => 0,
                                creatorName    => "",
                                creatorID      => undef,
                                hq             => 1,
                                isCrafted      => 0,
                                listingID      => int(rand(1000000000000000)),
                                materia        => [],
                                onMannequin    => 0,
                                retainerCity   => 12,
                                retainerID     => int(rand(10000000000000000)),
                                retainerName   => "lorem ipsum",
                                sellerID       => undef,
                                total          => 300,
                                tax            => 15
                            }],
                            worldName => 'zeromus',
                        }
                    },
                ],
            );
        };

        describe 'case call current_data method' => sub {
            it 'when returns sales data' => sub {
                my $res = Oden::API::Universalis->current_data(+{
                         item_ids    => [36213],
                         world_or_dc => $hash->{world_or_dc},
                });

                ref_ok $res,                      'HASH',                              'returns sales data';
                like   $res->{lastUploadTime},    qr/\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}/, 'lastUploadTime';
                is     scalar @{$res->{records}}, 1,                                   'records';
                for my $records (@{$res->{records}}) {
                    is $records->{onMannequin},                       0, 'onMannequin';
                    ok $records->{lastReviewTime},                       'lastReviewTime';
                    is $records->{pricePerUnit},                    300, 'pricePerUnit';
                    is $records->{quantity},                          1, 'quantity';
                    is $records->{retainerCity},                     12, 'retainerCity';
                    is $records->{total},                           300, 'total';
                    is $records->{hq},                                1, 'hq';
                    is $records->{worldName},                  'zeromus', 'worldName';
                }
            };
        };
    };
};

done_testing();
