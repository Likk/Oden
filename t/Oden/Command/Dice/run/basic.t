use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dice;

describe 'about Oden::Command::Dice#run' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case no parametor' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => '',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Dice->run();
                } qr/Too few arguments for fun run/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case message is ""' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => '',
                    guild_id => 1,
                    username => 'test_dict_get',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns emoticon of 1d6 result' => sub {
                my $entity  = Oden::Command::Dice->run($hash->{receiver});
                my $content = $entity->as_content;
                like $content, qr/[1⃣2⃣3⃣4⃣5⃣6⃣]/;
            };
        };
    };

};

runtests();
