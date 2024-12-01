use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use File::Temp qw/tempdir/;
use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Oden::Command::Dictionary#run' => sub {
    my $hash;

    describe 'case message pattern is `file`' => sub {
        before_all "setup CommunicationReceiver" => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => 'file',
                guild_id => 1,
                username => 'test_dict_show',
            );
            $hash->{receiver} = $receiver;

            $hash->{mocks} = mock "Oden::Model::Dictionary" => (
                override => [
                    create_tsv_file => sub {
                        return '/tmp/foo/bar.tsv'
                    },
                ],
            );
        };

        it 'when returns undef' => sub {
            my $entity = Oden::Command::Dictionary->run($hash->{receiver});
            isa_ok $entity,           ['Oden::Entity::CommunicationEmitter::FileDownload'], 'instance is Oden::Entity::CommunicationEmitter::FileDownload';
            is     $entity->filename, '/tmp/foo/bar.tsv',                                   'file value';
        };
    };
};

done_testing();
