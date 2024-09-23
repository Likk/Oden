use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;

use Oden::API::Universalis;

describe 'about Oden::API::Universalis#current_data' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case no parameter' => sub {
            it 'when no parameter' => sub {
                throws_ok {
                    my $res = Oden::API::Universalis->current_data();
                } qr/Too few arguments for fun current_data/, 'no parameter';
            };
        };
        context 'required parameter' => sub {
            context 'case no item_ids' => sub {
                it 'when no item_ids' => sub {
                    my $res = Oden::API::Universalis->current_data(+{
                        world_or_dc => 'zeromus',
                    });
                    is $res, undef, 'no item_ids';
                };
            };
            context 'case no world_or_dc' => sub {
                it 'when no world_or_dc' => sub {
                    my $res = Oden::API::Universalis->current_data(+{
                        item_ids => [36213],
                    });
                    is $res, undef, 'no world_or_dc';
                };
            };
            context 'case item_ids is not arrayref' => sub {
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

    context "Positive testing" => sub {
        before all => sub {
            $hash->{world_or_dc} = 'zeromus';
            Oden::API::Universalis->stubs(+{
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
                    }
                },
            });
        };

        context 'case call current_data method' => sub {
            it 'when returns sales data' => sub {
                my $res = Oden::API::Universalis->current_data(+{
                         item_ids    => [36213],
                         world_or_dc => $hash->{world_or_dc},
                });

                isa_ok $res, 'HASH', 'returns sales data';
                like $res->{lastUploadTime}, qr/\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}/, 'lastUploadTime';
                is scalar @{$res->{entry}}, 1, 'entry';
                for my $entry (@{$res->{entry}}) {
                    is $entry->{onMannequin},                       0, 'onMannequin';
                    ok $entry->{lastReviewTime},                       'lastReviewTime';
                    is $entry->{pricePerUnit},                    300, 'pricePerUnit';
                    is $entry->{quantity},                          1, 'quantity';
                    is $entry->{retainerCity},                     12, 'retainerCity';
                    is $entry->{total},                           300, 'total';
                    is $entry->{hq},                                1, 'hq';
                    is $entry->{worldName},      $hash->{world_or_dc}, 'worldName';
                }
            };
        };
    };
};

runtests();
