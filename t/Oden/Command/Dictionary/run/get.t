use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use File::Temp qw/tempdir/;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Oden::Command::Dictionary#run' => sub {
    my $hash;

    describe 'message prefix `get`' => sub {
        # Negative testing
        describe 'case message pattern is `get` only. no key, no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'get',
                    guild_id => 1,
                    username => 'test_dict_get',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        # Positive testing
        describe 'case message pattern is `get <key>`' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'get foo',
                    guild_id => 1,
                    username => 'test_dict_get',
                );
                $hash->{receiver} = $receiver;

            };
            describe 'case success' => sub {
                before_all "mockup Oden::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Oden::Model::Dictionary" => (
                        override => [
                            get => sub {
                                return 'bar';
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Oden::Entity::CommunicationEmitter'], 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'bar', 'get value';
                };
            };
            describe 'case failure' => sub {
                before_all "mockup Oden::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Oden::Model::Dictionary" => (
                        override => [
                            get => sub {
                                return undef;
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Oden::Entity::CommunicationEmitter'], 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'not registrated', 'failed to get';
                };
            };
        };
    };

};

done_testing();
