use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::Bot::Discord;

describe 'about Oden::Bot::Discord#run' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{stubs} =+{
            connect => AnyEvent::WebSocket::Client->stubs(
                connect => sub {
                    $hash->{called}->{connect} = 1;
                    return AE::cv;
                },
            ),
            recv => AnyEvent::CondVar->stubs(
                recv => sub {
                    $hash->{called}->{recv} = 1;
                },
            ),
        };
    };

    context 'when call run method' => sub {
        before all => sub {
            my $discord_bot = Oden::Bot::Discord->new(token => 'your token');
            $hash->{bot}    = $discord_bot->run();

        };
        it 'return AnyEvent::Discord instance that has events and connect' => sub {
            my $bot       = $hash->{bot};
            my $events    = $bot->_events;

            is $hash->{called}->{connect}, 1, 'called AnyEvent::WebSocket::Client#connect';
            is $hash->{called}->{recv},    1, 'called AnyEvent#condvar';

            my $message_create = Sub::Meta->new(sub => $events->{message_create}->[0]);
            my $message_update = Sub::Meta->new(sub => $events->{message_update}->[0]);
            my $ready          = Sub::Meta->new(sub => $events->{ready}->[0]         );

            is $message_create->fullname, 'Oden::Bot::Discord::MessageCreate::message_create';
            is $message_update->fullname, 'Oden::Bot::Discord::MessageUpdate::message_update';
            is $ready->fullname,          'Oden::Bot::Discord::Ready::ready';
        };
    };
};

runtests;
