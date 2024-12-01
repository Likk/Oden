use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dice;

describe 'about Oden::Command::Dice#run' => sub {
    my $hash;

    describe 'case message is "loot"' => sub {
        before_all "setup CommunicationReceiver"=> sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => 'loot',
                guild_id => 1,
                username => 'test',
            );
            $hash->{receiver} = $receiver;
        };

        tests 'when returns 1to99 result' => sub {
            for (1..100){
                my $entity  = Oden::Command::Dice->run($hash->{receiver});
                my $content = $entity->as_content;
                my ($loot, $mention) = split /\s/, $content;
                like $loot,       qr/\d{1,2}/;
                is   $loot <= 99, 1;
                is   $loot >= 1,  1;
                is   $mention,    '@test';
            }
        };
    };

};

done_testing();
