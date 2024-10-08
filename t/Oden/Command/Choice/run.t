use strict;
use warnings;

use Test::Exception;
use Test::Spec;

use Oden::Entity::CommunicationReceiver;
use Oden::Command::Choice;

describe 'about Oden::Command::Choice#run' => sub {
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
                    Oden::Command::Choice->run();
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
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity  = Oden::Command::Choice->run($hash->{receiver});
                is $entity->is_empty, 1;
            };
        };
        context 'case message is "a b c"' => sub {
            before all => sub {
                my $receiver = Oden::Entity::CommunicationReceiver->new(
                    message  => 'a b c',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            they 'when returns entity' => sub {
                for(1..10){
                    my $entity  = Oden::Command::Choice->run($hash->{receiver});
                    my $content = $entity->as_content;
                    like $content, qr/\A[abc]\z/;
                }
            };
        };
    };

};

runtests();
