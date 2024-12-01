use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dice;

describe 'about Oden::Command::Dice#run' => sub {
    my $hash;

    describe 'case message is qr/PARSE_ROLL_PATTERN/' => sub {
        before_all "setup CommunicationReceiver" => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => '2d10',
                guild_id => 1,
                username => 'test',
            );
            $hash->{receiver} = $receiver;

            $hash->{mocks}->{command_dice} = mock "Oden::Command::Dice" => (
                override => [
                    roll_trpg => sub {
                        return (int(rand(10)) + 1) + (int(rand(10)) + 1);
                    },
                ],
            );
        };

        it 'when returns emoticon of 1d6 result' => sub {
            my $entity  = Oden::Command::Dice->run($hash->{receiver});
            my $content = $entity->as_content;
            like $content, qr/\d{1,2}\s\@test/;
        };
    };
};

done_testing();
