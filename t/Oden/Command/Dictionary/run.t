use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use File::Temp qw/tempdir/;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Oden::Command::Dictionary#run' => sub {
    my $hash;

    describe 'case no parametor' => sub {
        before_all "setup CommunicationReceiver" => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => '',
                guild_id => 1,
                username => 'test_dict_get',
            );
            $hash->{receiver} = $receiver;
        };

        it 'when throws exception' => sub {
            my $throws = dies {
                Oden::Command::Dictionary->run();
            };

            like $throws, qr/Too few arguments for fun run/;
        };
    };

    describe 'case message is ""' => sub {
        before_all "setup CommunicationReceiver" => sub {
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

    describe 'case message is mistake prefix' => sub {
        before_all "]etup CommunicationReceiver" => sub {
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

done_testing();
