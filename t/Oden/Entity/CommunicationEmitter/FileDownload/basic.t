use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationEmitter::FileDownload;

describe 'about Oden::Entity::CommunicationEmitter::FileDownload#new' => sub {
   my $hash;

   before_all "setup" => sub {
       $hash->{entity} = Oden::Entity::CommunicationEmitter::FileDownload->new();
   };

   describe 'case call method' => sub {
        it 'should return Oden::Entity::CommunicationEmitter::FileDownload instance' => sub {
            my $entity = $hash->{entity};
            isa_ok $entity, ['Oden::Entity::CommunicationEmitter::FileDownload'], 'instance is Oden::Entity::CommunicationEmitter::FileDownload';
        };
    };
};

done_testing();
