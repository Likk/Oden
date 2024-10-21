package Oden::Bot::Discord;
use 5.40.0;

use AnyEvent::Discord;
use Function::Parameters;
use Function::Return;

use Oden::AnyEvent::Discord;
use Oden::Bot::Discord::Ready;
use Oden::Bot::Discord::MessageCreate;
use Oden::Bot::Discord::MessageUpdate;

use Types::Standard -types;

method new($class: %args) :Return(InstanceOf['Oden::Bot::Discord']) {
    return bless {%args}, $class;
};

method run() {
    my $bot = AnyEvent::Discord->new({
        token   => $self->{token},
    });

    $bot->on('ready'          => \&Oden::Bot::Discord::Ready::ready );
    $bot->on('message_create' => \&Oden::Bot::Discord::MessageCreate::message_create );
    $bot->on('message_update' => \&Oden::Bot::Discord::MessageUpdate::message_update );

    $bot->connect();
    AnyEvent->condvar->recv;
};
