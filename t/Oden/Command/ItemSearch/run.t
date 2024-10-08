use strict;
use warnings;
use utf8;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::ItemSearch;

describe 'about Oden::Command::ItemSearch#run' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case call run method without arguments' => sub {
            it 'when exception is thrown' => sub {
                throws_ok {
                    Oden::Command::ItemSearch->run();
                } qr/Too few arguments for fun run/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case call run method with official name_ja' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'アラグ錫貨',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };
            it 'when returns item object' => sub {
                my $entity = Oden::Command::ItemSearch->run($hash->{receiver});
                my $content = $entity->as_content;
                like $content, qr{\Alodestone:\shttps://jp.finalfantasyxiv.com/lodestone/playguide/db/item/([0-9a-f]{11})?/\n\z};
            };
        };

        context 'case call run method with prefix of official name_ja' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'アラグ',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };
            it 'when returns item object' => sub {
                my $entity = Oden::Command::ItemSearch->run($hash->{receiver});
                my $content = $entity->as_content;
                like $content, qr{\Amaybe:\n};
            };
        };

        context 'case call run method with un official name_ja' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'そんなものはない',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Oden::Command::ItemSearch->run($hash->{receiver});
                is $entity->is_empty, 1;
            };
        };
    };
};

runtests();
