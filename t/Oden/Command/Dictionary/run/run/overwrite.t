use strict;
use warnings;

use Test::Spec;

use File::Temp qw/tempdir/;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Oden::Command::Dictionary#run' => sub {
    my $hash;
    share %$hash;

    context 'message prefix `overwrite`' => sub {
        # Negative testing
        context 'case message pattern is `overwrite` only. no key, no value' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'overwrite',
                    guild_id => 1,
                    username => 'test_dict_overwrite',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        context 'case message pattern is `overwrite <key>` only. no value' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'overwrite foo',
                    guild_id => 1,
                    username => 'test_dict_overwrite',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        # Positive testing
        context 'case message pattern is `overwrite <key> <value>`' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'overwrite foo bar',
                    guild_id => 1,
                    username => 'test_dict_overwrite',
                );
                $hash->{receiver} = $receiver;

            };
            context 'case success' => sub {
                before all => sub {
                    $hash->{mock}->{dict} = Oden::Model::Dictionary->stubs('overwrite', sub {
                        return 1;
                    });
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity, 'Oden::Entity::CommunicationEmitter', 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'overwrote', 'overwrite key and value';
                };
            };
            context 'case failure' => sub {
                before all => sub {
                    $hash->{mock}->{dict} = Oden::Model::Dictionary->stubs('overwrite', sub {
                        return 0;
                    });
                };

                it 'when returns undef' => sub {
                    my $entity = Oden::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity, 'Oden::Entity::CommunicationEmitter', 'instance is Oden::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'not registrated', 'failed to overwrite key and value';
                };
            };
        };
    };

};

runtests();
