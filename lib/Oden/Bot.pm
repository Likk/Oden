package Oden::Bot;

use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Oden::Entity::CommunicationReceiver;
use Oden::CommandRouter;

use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationEmitter" => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=encoding utf8

=head1 NAME

  Oden::Bot

=head1 DESCRIPTION

  Odeb bot is a main logic of chat bot.
  # チャットボットのクライアントシステムに依存しないロジックを記述する

=head1 SYNOPSIS

  use Oden::Bot;
  my $res = $bot->talk($content, $guild_id, $username);

=head1 METHODS

=head2 talk

  talk method is a main logic of chat bot.
  It create a receiver object and route a command.
  It returns a emitter object.

  Args:
    Str $content
    Int $guild_id
    Str $username

  Returns:
    Maybe[Str]|Oden::Entity::CommunicationEmitter

=cut

method talk(Str $content, Int $guild_id, Str $username) :Return(Maybe[Str]|Oden::Entity::CommunicationEmitter) {
    return undef unless $content;

    my $command_router = Oden::CommandRouter->new();
    my $receiver       = Oden::Entity::CommunicationReceiver->new(
        message  => $content,
        guild_id => $guild_id,
        username => $username,
    );

    # Automatically responds to chat messages not starting with '/'.
    # Fas paassive commands take precedence over '/'-initiated commands
    my $fast_passive_commands = $command_router->fast_passive_commands;
    for my $command (@$fast_passive_commands){
        my $emitter = $command->run($receiver);
        return $emitter if $emitter;
    }

    # Responds to chat messages starting with '/'.
    my ($command, $message);
    if($content =~ m{\A/(?<command>\w+)(?:\s+(?<message>.*))?\z}){
        $command = $+{command} || '';
        $message = $+{message} || '';
        if(my $command = $command_router->route_active($command)){
            $receiver->message($message);
            my $emitter = $command->run($receiver);
            return $emitter if $emitter;
        }
    }

    # TODO:
    # Automatically responds to chat messages not starting with '/'.
    # passive commands is lower priority than passive commands

    return undef;
}
