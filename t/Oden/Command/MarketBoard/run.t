use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::MarketBoard;

describe 'about Oden::Command::MarketBoard#run' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case no parametor' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    Oden::Command::MarketBoard->run();
                };

                like $throws, qr/Too few arguments for fun run/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case not tradaable item' => sub {
            before_all "setup CommunicationReceiver" => sub {
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
        describe 'case market api error"' => sub {
            before_all "mockup Oden::API::Universalis" => sub {

                my $mocks = mock "Oden::API::Universalis" => (
                    override => [
                        current_data => sub { return undef; },
                    ],
                );

                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'japan Lalafellin Kaftan',
                    guild_id => 1,
                    username => 'test',
                );

                $hash->{mocks}    = $mocks;
                $hash->{receiver} = $receiver;

            };

            after_all "mockup Oden::API::Universalis" => sub {
                delete $hash->{mocks};
            };

            it 'when returns error message' => sub {
                my $entity = Oden::Command::MarketBoard->run($hash->{receiver});
                is $entity->as_content, 'Oops! Cannot read response. Retry at a later time', 'error message';
            };
        };

        describe 'case successful' => sub {
            before_all "mockup Oden::API::Universalis" => sub {
                my $mocks = +{
                    oden_model_item => mock("Oden::Model::Item" => (
                        override => [
                            lookup_item_by_name => sub {
                                return bless +{
                                    id                => 2988,
                                    lang              => 'en',
                                    name              => 'Lalafellin Kaftan',
                                    EquipSlotCategory => 4,
                                    IsUntradable      => 'False',
                                }, 'Oden::Model::Item';
                            },
                        ],
                    )),
                    oden_api_universalis => mock("Oden::API::Universalis" => (
                        override => [
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
                        ]
                    )),
                };

                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'zeromus Lalafellin Kaftan',
                    guild_id => 1,
                    username => 'test',
                );

                $hash->{mocks}    = $mocks;
                $hash->{receiver} = $receiver;

            };

            after_all "mockup Oden::API::Universalis" => sub {
                delete $hash->{mocks};
            };

            it 'when returns response' => sub {
                my $entity = Oden::Command::MarketBoard->run($hash->{receiver});
                like $entity->as_content, qr/last update: 2013\/08\/27 17:00/, 'last update';
            };
        };
    };

};

done_testing();
