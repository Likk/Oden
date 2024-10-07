use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Dice;

describe 'about Oden::Command::Dice#run' => sub {
    my $hash;
    share %$hash;

    context 'case message is "loot"' => sub {
        before all => sub {
            my $receiver = Oden::Entity::CommunicationReceiver->new(
                message  => 'loot',
                guild_id => 1,
                username => 'test',
            );
            $hash->{receiver} = $receiver;
        };

        they 'when returns 1to99 result' => sub {
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

runtests();
