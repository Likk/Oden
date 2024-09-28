use strict;
use warnings;
use utf8;
use Test::Spec;
use Oden::Entity::CommunicationEmitter::FileDownload;

describe 'about Oden::Entity::CommunicationEmitter::FileDownload#new' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{entity} = Oden::Entity::CommunicationEmitter::FileDownload->new();
        };

        context 'case normal' => sub {
            it 'should return Oden::Entity::CommunicationEmitter::FileDownload instance' => sub {
                my $entity = $hash->{entity};
                isa_ok $entity,                          'Oden::Entity::CommunicationEmitter::FileDownload', 'instance is Oden::Entity::CommunicationEmitter::FileDownload';
            };
        };
    };
};

runtests;
