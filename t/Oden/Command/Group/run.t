use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Group;
use String::Random;

describe 'about Oden::Command::Group#run' => sub {
    my $hash;

    # Negative testing
    describe 'Negative testing' => sub {
        describe 'case call run method without arguments' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    Oden::Command::Group->run();
                };

                like $throws, qr/Too few arguments for fun run/;
            };
        };
        describe 'case call run method with not expectd class' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    my $random_class = bless {}, sprintf('Oden::Entity::%s', String::Random->new->randregex("[A-Za-z]{3,10}"));
                    Oden::Command::Group->run($random_class);
                };

                like $throws, qr/did not pass type constraint/;
            };
        };
    };

    # Positive testing
    describe 'Positive testing' => sub {
        describe 'case call run method with Oden::Entity::CommunicationReceiver class' => sub {
            before_all "mockup Oden::Command::Group" => sub {
                $hash->{make_groups_mock} = mock "Oden::Command::Group" => (
                    override => [
                        make_groups => sub {
                            return [
                                [qw/foo bar/],
                            ];
                        },
                    ],
                );
            };
            describe 'case call run method with Oden::Entity::CommunicationReceiver class without message' => sub {
                it 'when returns empty Oden::Entity::CommunicationEmitter' => sub {
                    my $receiver = Oden::Entity::CommunicationReceiver->new(
                        message  => '',
                        guild_id => 1,
                        username => 'foo',
                    );
                    my $res = Oden::Command::Group->run($receiver);
                    isa_ok $res,           ['Oden::Entity::CommunicationEmitter'];
                    is     $res->is_empty, 1;
                };
            };
            describe 'case call run method with Oden::Entity::CommunicationReceiver class with message' => sub {
                describe 'message is space only' => sub {
                    it 'when returns empty Oden::Entity::CommunicationEmitter' => sub {
                        my $receiver = Oden::Entity::CommunicationReceiver->new(
                            message  => '      ',
                            guild_id => 1,
                            username => 'foo',
                        );
                        my $res = Oden::Command::Group->run($receiver);
                        isa_ok $res,           ['Oden::Entity::CommunicationEmitter'];
                        is     $res->is_empty, 1;
                    };
                };
                describe 'message is member names only' => sub {
                    it 'when returns Oden::Entity::CommunicationEmitter and that has message' => sub {
                        my $receiver = Oden::Entity::CommunicationReceiver->new(
                            message  => 'foo bar baz',
                            guild_id => 1,
                            username => 'foo',
                        );
                        my $res = Oden::Command::Group->run($receiver);
                        isa_ok $res,          ['Oden::Entity::CommunicationEmitter'];
                        like   $res->message, qr/Group 1/;
                    };
                };
                describe 'message is group number and member names' => sub {
                    it 'when returns Oden::Entity::CommunicationEmitter and that has message' => sub {
                        # 2 <= number <= 5
                        my $number = int(rand(4)) + 2;
                        # 2 <= members <= 10
                        my $members = join ' ', map { String::Random->new->randregex("[A-Za-z]{3,10}") } 1..int(rand(9)) + 2;
                        my $receiver = Oden::Entity::CommunicationReceiver->new(
                            message  => sprintf("%d %s", $number, $members),
                            guild_id => 1,
                            username => 'foo',
                        );
                        my $res = Oden::Command::Group->run($receiver);
                        isa_ok $res,          'Oden::Entity::CommunicationEmitter';
                        like   $res->message, qr/Group 1/;
                    };
                };
            };
        };
    };
};

done_testing();
