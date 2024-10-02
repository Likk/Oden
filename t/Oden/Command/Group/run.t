use strict;
use warnings;

use Test::Exception;
use Test::Spec;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Group;
use String::Random;

describe 'about Oden::Command::Group#run' => sub {
    my $hash;
    share %$hash;

    # Negative testing
    context 'Negative testing' => sub {
        context 'case call run method without arguments' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Group->run();
                } qr/Too few arguments for fun run/;
            };
        };
        context 'case call run method with not expectd class' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    my $random_class = bless {}, sprintf('Oden::Entity::%s', String::Random->new->randregex("[A-Za-z]{3,10}"));
                    Oden::Command::Group->run($random_class);
                } qr/did not pass type constraint/;
            };
        };
    };

    # Positive testing
    context 'Positive testing' => sub {
        context 'case call run method with Oden::Entity::CommunicationReceiver class' => sub {
            before all => sub {
                $hash->{make_groups_stub} = Oden::Command::Group->stubs(
                    make_groups => sub {
                        return [
                            [qw/foo bar/],
                        ];
                    },
                );
            };
            context 'case call run method with Oden::Entity::CommunicationReceiver class without message' => sub {
                it 'when returns empty Oden::Entity::CommunicationEmitter' => sub {
                    my $receiver = Oden::Entity::CommunicationReceiver->new(
                        message  => '',
                        guild_id => 1,
                        username => 'foo',
                    );
                    my $res = Oden::Command::Group->run($receiver);
                    isa_ok $res,           'Oden::Entity::CommunicationEmitter';
                    is     $res->is_empty, 1;
                };
            };
            context 'case call run method with Oden::Entity::CommunicationReceiver class with message' => sub {
                context 'message is space only' => sub {
                    it 'when returns empty Oden::Entity::CommunicationEmitter' => sub {
                        my $receiver = Oden::Entity::CommunicationReceiver->new(
                            message  => '      ',
                            guild_id => 1,
                            username => 'foo',
                        );
                        my $res = Oden::Command::Group->run($receiver);
                        isa_ok $res,           'Oden::Entity::CommunicationEmitter';
                        is     $res->is_empty, 1;
                    };
                };
                context 'message is member names only' => sub {
                    it 'when returns Oden::Entity::CommunicationEmitter and that has message' => sub {
                        my $receiver = Oden::Entity::CommunicationReceiver->new(
                            message  => 'foo bar baz',
                            guild_id => 1,
                            username => 'foo',
                        );
                        my $res = Oden::Command::Group->run($receiver);
                        isa_ok $res,          'Oden::Entity::CommunicationEmitter';
                        like   $res->message, qr/Group 1/;
                    };
                };
                context 'message is group number and member names' => sub {
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

runtests();
