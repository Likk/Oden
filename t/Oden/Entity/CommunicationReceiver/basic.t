use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;

describe 'about Oden::Entity::CommunicationReceiver#new' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{oden} = Oden::Entity::CommunicationReceiver->new(
                message  => 'test message',
                guild_id => 1234567890,
                username => 'nickname',
            );
        };
        it 'should return Oden::Entity::CommunicationReceiver instance' => sub {
            my $entity = Oden::Entity::CommunicationReceiver->new(
                message  => 'test message',
                guild_id => 1234567890,
                username => 'nickname',
            );
            isa_ok $entity,          ['Oden::Entity::CommunicationReceiver'], 'instance is Oden::Entity::CommunicationReceiver';
            is     $entity->message, 'test message',                          'message is "test message"';
            is     $entity->guild_id, 1234567890,                             'guild_id is 1234567890';
            is     $entity->username, 'nickname',                             'username is "nickname"';
        };
    };
};

done_testing();
