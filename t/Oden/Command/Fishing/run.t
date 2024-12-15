use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationReceiver;
use Oden::Command::Fishing;

describe 'about Oden::Command::Fishing#run' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case call run method without arguments' => sub {
            it 'when exception is thrown' => sub {
                my $throws = dies {
                    Oden::Command::Fishing->run();
                };

                like $throws, qr/Too few arguments for fun run/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case empty message' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => '',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Fishing->run($hash->{receiver});
                is $entity->is_empty, 1;
            };
        };

        describe 'case call run method with official name_ja' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'ロミンサンアンチョビ',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };
            it 'when returns item object' => sub {
                my $entity = Oden::Command::Fishing->run($hash->{receiver});
                my $content = $entity->as_content;
                like $content, qr{\Ateamcraft:\shttps://ffxivteamcraft.com/db/ja/item/([0-9a-f]+)/\n\z};
            };
        };

        describe 'case call run method with un official name_ja' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'そんな魚はいない',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::Fishing->run($hash->{receiver});
                is $entity->is_empty, 1;
            };
        };
    };
};

done_testing();
