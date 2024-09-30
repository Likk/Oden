use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use File::Temp qw/tempdir/;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Oden::Command::Dictionary#run' => sub {
    my $hash;
    share %$hash;

    context 'case no parametor' => sub {
        before all => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => '',
                guild_id => 1,
                username => 'test_dict_get',
            );
            $hash->{receiver} = $receiver;
        };

        it 'when throws exception' => sub {
            throws_ok {
                Oden::Command::Dictionary->run();
            } qr/Too few arguments for fun run/;
        };
    };

    context 'case message is ""' => sub {
        before all => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => '',
                guild_id => 1,
                username => 'test_dict_get',
            );
            $hash->{receiver} = $receiver;
        };

        it 'when returns undef' => sub {
            my $entity = Oden::Command::Dictionary->run($hash->{receiver});
            is $entity, undef;
        };
    };

    context 'case message is mistake prefix' => sub {
        before all => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => 'regist',
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

};

runtests();
