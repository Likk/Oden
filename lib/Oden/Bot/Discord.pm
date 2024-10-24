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

=head1 NAME

  Oden::Bot::Discord

=head1 DESCRIPTION

  Oden::Bot::Discord is a discord bot starter.

=head1 SYNOPSIS

  my $bot = Oden::Bot::Discord->new({
      token => $token,
  });
  $bot->run;

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  create and return a new discord bot object.

=cut

method new($class: %args) :Return(InstanceOf['Oden::Bot::Discord']) {
    return bless {%args}, $class;
};

=head1 METHODS

=head2 run

  setup event handler and launch discord bot.

=cut

method run() {
    my $bot = AnyEvent::Discord->new({
        token   => $self->{token},
    });

    $bot->on('ready'          => \&Oden::Bot::Discord::Ready::ready );
    $bot->on('message_create' => \&Oden::Bot::Discord::MessageCreate::message_create );
    $bot->on('message_update' => \&Oden::Bot::Discord::MessageUpdate::message_update );

    $bot->connect();
    AnyEvent->condvar->recv;

    return $bot;
};

=head1 SEE ALSO

L<AnyEvent::Discord>

=cut
