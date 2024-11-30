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

    describe 'message prefix `set`' => sub {
        # Negative testing
        describe 'case message pattern is `set` only. no key, no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'set',
                    guild_id => 1,
                    username => 'test_dict_set',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        describe 'case message pattern is `set <key>` only. no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'set foo',
                    guild_id => 1,
                    username => 'test_dict_set',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        # Positive testing
        describe 'case message pattern is `set <key> <value>`' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'set foo bar',
                    guild_id => 1,
                    username => 'test_dict_set',
                );
                $hash->{receiver} = $receiver;

            };
            describe 'case success' => sub {
                before_all "mockup Oden::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Oden::Model::Dictionary" => (
                        override => [
                            set => sub {
                                return 1;
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Oden::Entity::CommunicationEmitter'], 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'registrated',                          'set key and value';
                };
            };
            describe 'case failure' => sub {
                before_all "mockup Oden::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Oden::Model::Dictionary" => (
                        override => [
                            set => sub {
                                return 0;
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Oden::Entity::CommunicationEmitter'], 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'the key already exists',               'failed to set key and value';
                };
            };
        };
    };

};

done_testing();
