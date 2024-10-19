use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::MarketBoard;

describe 'about Oden::Command::MarketBoard#run' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case no parametor' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::MarketBoard->run();
                } qr/Too few arguments for fun run/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case not tradaable item' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'zeromus Antique Mail',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;

            };

            it 'when returns empty message' => sub {
                my $entity  = Oden::Command::MarketBoard->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty message';
            };
        };
        context 'case market api error"' => sub {
            before all => sub {

                my $stubs = +{
                    oden_api_universalis => Oden::API::Universalis->stubs(
                        current_data => sub { return undef; },
                    ),
                };
                $hash->{stubs} = $stubs;

                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'japan Lalafellin Kaftan',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;

            };

            after all => sub {
                delete $hash->{stubs};
            };

            it 'when returns error message' => sub {
                my $entity = Oden::Command::MarketBoard->run($hash->{receiver});
                is $entity->as_content, 'Oops! Cannot read response. Retry at a later time', 'error message';
            };
        };

        context 'case successful' => sub {
            before all => sub {
                my $stubs = +{
                    oden_model_item => Oden::Model::Item->stubs(
                        lookup_item_by_name => sub {
                            return bless +{
                                id                => 2988,
                                lang              => 'en',
                                name              => 'Lalafellin Kaftan',
                                EquipSlotCategory => 4,
                                IsUntradable      => 'False',
                            }, 'Oden::Model::Item';
                        },
                    ),
                    oden_api_universalis => Oden::API::Universalis->stubs(
                        current_data => sub {
                            return +{
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
                        },
                    ),
                };
                $hash->{stubs} = $stubs;

                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'zeromus Lalafellin Kaftan',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;

            };

            after all => sub {
                delete $hash->{stubs};
            };

            it 'when returns response' => sub {
                my $entity = Oden::Command::MarketBoard->run($hash->{receiver});
                like $entity->as_content, qr/last update: 2013\/08\/27 17:00/, 'last update';
            };
        };
    };

};

runtests();
