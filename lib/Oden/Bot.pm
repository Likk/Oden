package Oden::Bot;

use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Oden::Command::AYT;
use Oden::Entity::CommunicationReceiver;
use Oden::Dispatcher;

use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationEmitter" => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Bot

=head1 DESCRIPTION

  Odeb bot is a main logic of chat bot.
  # チャットボットのクライアントシステムに依存しないロジックを記述する

=head1 METHODS

=head2 talk

  talk method is a main logic of chat bot.
  It create a receiver object and dispatch a command.
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

    # ping.
    if(my $res = Oden::Command::AYT->run($content)){
        return $res;
    }

    my ($command, $message);
    if($content =~ m{\A/(?<command>\w+)(?:\s+(?<message>.*))?\z}){
        $command = $+{command} || '';
        $message = $+{message} || '';
    }
    return undef unless $command;

    my $package = Oden::Dispatcher->dispatch($command);
    return undef unless $package;

    my $entity = Oden::Entity::CommunicationReceiver->new(
        message  => $message,
        guild_id => $guild_id,
        username => $username,
    );

    try {
        my $emitter =  $package->run($entity);
        return $emitter;
    }
    catch ($e){
        warn $e;
    };
}
