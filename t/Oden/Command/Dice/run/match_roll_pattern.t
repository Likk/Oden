use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dice;

describe 'about Oden::Command::Dice#run' => sub {
    my $hash;
    share %$hash;

    context 'case message is qr/PARSE_ROLL_PATTERN/' => sub {
        before all => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => '2d10',
                guild_id => 1,
                username => 'test',
            );
            $hash->{receiver} = $receiver;

            $hash->{stubs}->{command_dice} = Oden::Command::Dice->stubs(
                roll_trpg => sub {
                    return (int(rand(10)) + 1) + (int(rand(10)) + 1);
                },
            );
        };

        it 'when returns emoticon of 1d6 result' => sub {
            my $entity  = Oden::Command::Dice->run($hash->{receiver});
            my $content = $entity->as_content;
            like $content, qr/\d{1,2}\s\@test/;
        };
    };
};

runtests();
