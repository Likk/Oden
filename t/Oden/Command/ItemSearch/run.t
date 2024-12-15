use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationReceiver;
use Oden::Command::ItemSearch;

describe 'about Oden::Command::ItemSearch#run' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case call run method without arguments' => sub {
            it 'when exception is thrown' => sub {
                my $throws = dies {
                    Oden::Command::ItemSearch->run();
                };

                like $throws, qr/Too few arguments for fun run/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case call run method with official name_ja' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
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

        describe 'case call run method with prefix of official name_ja' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
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

        describe 'case call run method with un official name_ja' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
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

done_testing();
