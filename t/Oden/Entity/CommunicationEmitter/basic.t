use 5.40.0;
use utf8;
use Test::Spec;
use Oden::Entity::CommunicationEmitter

describe 'about Oden::Entity::CommunicationEmitter#new' => sub {
    my $hash;
    share %$hash;

    context 'case empty message' => sub {
        before all => sub {
            $hash->{entity} = Oden::Entity::CommunicationEmitter->new(
                message  => '',
                username => 'nickname',
            );
        };

        it 'should return Oden::Entity::CommunicationEmitter instance' => sub {
            my $entity = $hash->{entity};
            isa_ok $entity,             'Oden::Entity::CommunicationEmitter', 'instance is Oden::Entity::CommunicationEmitter';
            is     $entity->as_content, '',                                    'message is ""';
            is     $entity->is_empty,   true,                                     'is_empty is true';
        };
    };

    context 'case non-empty message' => sub {
        before all => sub {
            $hash->{entity} = Oden::Entity::CommunicationEmitter->new(
                message  => 'test message',
                username => 'nickname',
            );
        };

        context 'case normal' => sub {
            it 'should return Oden::Entity::CommunicationEmitter instance' => sub {
                my $entity = $hash->{entity};
                isa_ok $entity,                          'Oden::Entity::CommunicationEmitter', 'instance is Oden::Entity::CommunicationEmitter';
                is     $entity->as_content,              'test message',                       'message is "test message"';
                is     $entity->is_empty,                false,                                    'is_empty is false';
            };
        };

        context 'case with_mention' => sub {
            it 'should return Oden::Entity::CommunicationEmitter instance' => sub {
                my $entity = $hash->{entity};
                $entity->mention_flag(1);
                is $entity->as_content, 'test message @nickname', 'message with mention'
            };
        };
    };
};

runtests;
