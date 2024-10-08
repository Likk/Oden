use strict;
use warnings;
use utf8;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Fishing;

describe 'about Oden::Command::Fishing#run' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case call run method without arguments' => sub {
            it 'when exception is thrown' => sub {
                throws_ok {
                    Oden::Command::Fishing->run();
                } qr/Too few arguments for fun run/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case empty message' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
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

        context 'case call run method with official name_ja' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
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

        context 'case call run method with un official name_ja' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
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

runtests();
